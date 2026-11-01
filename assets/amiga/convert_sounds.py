import subprocess,os,struct,glob,tempfile
import shutil

from shared import *

gamename = "rolling_thunder"
sox = "sox"
sound_dir_master = this_dir / ".." / "sounds"
sound_dir = sound_dir_master / "synth"
sample_dir = sound_dir_master / "voices"
tunes_dir = sound_dir_master / "tunes"

# default channel = 3, default priority = 40
# put below some exceptions
sound_settings_dict = {
##0x20 : {"channel":3,"priority":50,"loops":True},   # bomb
##6: {"channel":2,"priority":50},  # power
##2: {"channel":3,"priority":100}  # explosion
}

def convert():
    if not shutil.which("sox"):
        raise Exception("sox command not in path, please install it")
    # BTW convert wav to mp3: ffmpeg -i input.wav -codec:a libmp3lame -b:a 330k output.mp3

    out_dir = src_dir

    outfile = os.path.join(out_dir,"sounds.68k")
    sndfile = os.path.join(out_dir,"sound_entries.68k")

    low_memory = False

    hq_sample_rate = 11050  # if low_memory else 20000  #{"aga":18004,"ecs":12000,"ocs":11025}[mode]
    lq_sample_rate = hq_sample_rate//2 # if aga_mode else 8000


    loop_channel = 2

    EMPTY_SND = "EMPTY_SND"

    dummy_sounds = {
    3,   # a very faint step synth sound, would either not be heard or would cut an important sound
    0x20+8,  # other step sampled sounds, disabled for the same reason
    0x2C,    # step, again
    12,  # ??, plays in intermission
    }


    sound_dict = {}
    sfx_list = set()
    snd_chan = 0
    for sd,offset in ((sound_dir,0),(sample_dir,0x20)):
        # scan directory for speech
        for f in sd.glob("*.wav"):
            sound_name = f.stem
            parts = sound_name.rsplit("_",maxsplit=1)

            if len(parts)>1:
                try:
                    index = int(parts[1],16)
                    index += offset
                    if index not in dummy_sounds:



                        sfx_list.add(index)
                        # auto-declare according to name suffix
                        entry = f"{sound_name}_SND"
                        # fix channel to avoid overlap
                        extra_info = sound_settings_dict.get(index) or dict()

                        sfx_sample_rate = extra_info.get("sample_rate",lq_sample_rate)


                        sound_dict[entry] = {"directory":sd,"channel":extra_info.get("channel",snd_chan+2),  # default: not auto!
                        "priority":extra_info.get("priority",40),"index":index,"sample_rate":sfx_sample_rate,
                        "loops":extra_info.get("loops",False)}
                        snd_chan  = (snd_chan + 1) % 2
                except ValueError:
                    pass



    music_vol = 40

    music_dict = {
"LEVEL_COMPLETE_SND" : {"index":0xF5,"pattern":0,"volume":music_vol},
"MAIN_BGM_SND" : {"index":0xF6,"pattern":0,"volume":music_vol},
"MAIN_BGM_CONT_SND" : {"index":0xFE,"pattern":0,"volume":music_vol},
"BOSS_KILLED_SND" : {"index":0xF7,"pattern":0,"volume":56},
"MISSION_COMPLETE_SND" : {"index":0xF9,"pattern":0,"volume":music_vol},
"ALT_BGM_SND" : {"index":0xFA,"pattern":0,"volume":music_vol},
"ALT_BGM_CONT_SND" : {"index":0xFF,"pattern":0,"volume":music_vol},
"HIGH_SCORE_SND" : {"index":0xFB,"pattern":0,"volume":music_vol},
"GAME_OVER_SND" : {"index":0xFC,"pattern":0,"volume":music_vol},
}


    sound_dict.update(music_dict)



    with open(os.path.join(src_dir,"..","sounds.inc"),"w") as f:
        for k,v in sorted(sound_dict.items(),key = lambda x:x[1]["index"]):
            f.write(f"\t.equ\t{k.upper()},  0x{v['index']:x}\n")

    max_sound = 0x100  # max(x["index"] for x in sound_dict.values())+1
    sound_table = [""]*max_sound
    sound_table_set_1 = ["\t.long\t0,0"]*max_sound

    for d in dummy_sounds:
        sound_table_set_1[d] = "\t.word\t3,0,0,0   | valid but muted"



    snd_header = rf"""
    # sound tables
    #
    # the "sound_table" table has 8 bytes per entry
    # first word: 0: no entry, 1: sample, 2: pattern from music module
    # second word: 0 except for music module: pattern number
    # longword: sample data pointer if sample, 0 if no entry and
    # 2 words: 0/1 noloop/loop followed by duration in ticks
    #
    # SOUND_ENTRY macro defines a ptplayer-compatible structure, with added the number
    # of ticks (PAL) giving the duration of the sample (offset 0xA)
    FXFREQBASE = 3579564

        .macro    SOUND_ENTRY    sound_name,size,channel,soundfreq,volume,priority,ticks
    \sound_name\()_sound:
        .long    \sound_name\()_raw
        .word   \size
        .word   FXFREQBASE/\soundfreq,\volume
        .byte    \channel
        .byte    \priority
        .word    \ticks
        .endm

    """

    def write_asm(contents,fw):
        n=0
        for c in contents:
            if n%16 == 0:
                fw.write("\n\t.byte\t0x{:x}".format(c))
            else:
                fw.write(",0x{:x}".format(c))
            n += 1
        fw.write("\n")


    raw_file = os.path.join(tempfile.gettempdir(),"out.raw")
    with open(sndfile,"w") as fst,open(outfile,"w") as fw:
        fst.write(snd_header)

        fw.write("\t.section\t.datachip\n")



        for wav_file,details in sound_dict.items():
            wav_name = os.path.basename(wav_file).lower()[:-4]
            if details.get("channel") is not None:
                fw.write("\t.global\t{}_raw\n".format(wav_name))


        # write the table index => module (there are several modules now)


        for wav_entry,details in sound_dict.items():
            sound_index = details["index"]

            channel = details.get("channel")
            if channel is None:

                same_as = details.get("same_as")
                if same_as is None:
                    # if music loops, ticks are set to 1 so sound orders only can happen once (else music is started 50 times per second!!)

                    sound_table_set_1[sound_index] = "\t.word\t{},{},{}\n\t.byte\t{},{}".format(2,details["pattern"],0,details["volume"],int(details.get("loops",0)))
                else:
                    # aliased sound: reuse sample for a different sound index
                    wav_entry = same_as
                    details = sound_dict[same_as]
                    wav_name = wav_entry.lower()[:-4]
                    wav = os.path.splitext(wav_name)[0]
                    sound_table_set_1[sound_index] = f"\t.word\t1,{int(details.get('loops',0))}\n\t.long\t{wav}_sound"
            else:
                wav_name = wav_entry.lower()[:-4]
                wav_file = details["directory"] / f"{wav_name}.wav"

                def get_sox_cmd(sr,output):
                    return [sox,"--volume","3.3",wav_file,"--channels","1","-D","--bits","8","-r",str(sr),"--encoding","signed-integer",output]

                used_sampling_rate = details["sample_rate"]
                used_priority = details.get("priority",1)

                cmd = get_sox_cmd(used_sampling_rate,raw_file)

                subprocess.check_call(cmd)
                with open(raw_file,"rb") as f:
                    contents = f.read()

                # compute max amplitude so we can feed the sound chip with an amped sound sample
                # and reduce the replay volume. this gives better sound quality than replaying at max volume
                # (thanks no9 for the tip!)
                signed_data = [x if x < 128 else x-256 for x in contents]
                maxsigned = max(signed_data)
                minsigned = min(signed_data)

                amp_ratio = max(maxsigned,abs(minsigned))/32

                print(f"amp_ratio: {amp_ratio}")

                wav = os.path.splitext(wav_name)[0]
                if amp_ratio > 1:
                    print(f"{wav}: volume peaked {amp_ratio}")
                    amp_ratio = 1

                sound_table[sound_index] = "    SOUND_ENTRY {},{},{},{},{},{},{}\n".format(wav,len(signed_data)//2,channel,
                            used_sampling_rate,int(64*amp_ratio),used_priority,0)
                sound_table_set_1[sound_index] = f"\t.word\t1,{int(details.get('loops',0))}\n\t.long\t{wav}_sound"

                if amp_ratio > 0:
                    maxed_contents = [int(x/amp_ratio) for x in signed_data]
                else:
                    maxed_contents = signed_data



                signed_contents = bytes([x if x >= 0 else 256+x for x in maxed_contents])
                # pre-pad with 0W, used by ptplayer for idling
                if signed_contents[0] != b'\x00' and signed_contents[1] != b'\x00':
                    # add zeroes
                    signed_contents = struct.pack(">H",0) + signed_contents

                contents = signed_contents
                # align on 16-bit
                if len(contents)%2:
                    contents += b'\x00'
                # pre-pad with 0W, used by ptplayer for idling
                if contents[0] != b'\x00' and contents[1] != b'\x00':
                    # add zeroes
                    contents = b'\x00\x00' + contents

                fw.write("{}_raw:   | {} bytes".format(wav,len(contents)))

                if len(contents)>65530:
                    raise Exception(f"Sound {wav_entry} is too long")
                write_asm(contents,fw)



        fw.write("\t.align\t8\n")


        fst.writelines(sound_table)
        fst.write("\n\t.global\t{0}\n\n{0}:\n".format("sound_table"))
        for i,st in enumerate(sound_table_set_1):
            fst.write(st)
            fst.write(f" | 0x{i:02x}\n")

    music_list = {v["index"] for v in music_dict.values()}


    unused_indexes = set(range(0,0x3E))-sfx_list-music_list
    print("Unmapped sound indexes: ")
    print(sorted(hex(x) for x in unused_indexes))

    for mod in tunes_dir.glob("*.mod"):
        shutil.copy(mod,data_dir)
convert()


