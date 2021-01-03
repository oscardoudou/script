#!/bin/bash

#convert xml to ass using Danmaku2Ass
xmls=(); for i in {1..12}_*; do if [ -s "$i" ] ; then xmls[${i%%_*}]+=$i\ ; fi ; done
# for i in ${!xmls[@]}; do echo ${xmls[i]}; done
for i in ${!xmls[@]}; do 
    danmaku2ass -o $i.ass -s 1920x1080 -fs 50 -a 0.7 -dm 10 -ds 7 -p 100 ${xmls[i]} ;
    # need shift (add negative delay value to fastword the subtitle so it could sync)
    ffmpeg -itsoffset -13 -i $i.ass -c copy danmaku_$(printf %02d.ass ${i%.ass}) && rm $i.ass ;
done

# unify the encoding of subtitle ass utilizing the cycle to rename episode as zero leading
for f in *Freezing*.ass; do iconv -f utf-16 -t utf-8 < "$f" > sub_$(echo "$f" | sed -E 's/^.*Freezing\]\[([0-9]*)\]\[BD.*$/\1/g').ass ; done

# merge begin
for sub in sub_*.ass; do
    index=$(echo $sub | sed -E 's/^sub_([0-9]*).ass$/\1/g')
    danmaku=danmaku_$index.ass
    # add the input validation check here for now
    if [ -f $danmaku ]; then
        ./merge_ass.sh $danmaku $sub
        rm $danmaku $sub
    else
        mv $sub ${sub%%.*}_danmaku.ass 
    fi
done

# burn 
./burn.sh
