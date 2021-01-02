#!/bin/bash

#convert xml to ass using Danmaku2Ass
xmls=(); for i in {1..12}_*; do if [ -s "$i" ] ; then xmls[${i%%_*}]+=$i\ ; fi ; done
# for i in ${!xmls[@]}; do echo ${xmls[i]}; done
for i in ${!xmls[@]}; do danmaku2ass -o $i.ass -s 1920x1080 -fn "MS PGothic" -fs 48 -a 0.8 -dm 7 -ds 5 ${xmls[i]} ; done

# need shift( add negative delay value to fastword the subtitle so it could sync)
for i in ${!xmls[@]}; do ffmpeg -itsoffset -16 -i $i.ass -c copy danmaku_$i.ass && rm $i.ass ; done

# unify the encoding of subtitle ass
for f in *Freezing*; do iconv -f utf-16 -t utf-8 < "$f" > sub_$(echo "$f" | sed -E 's/^.*Freezing\]\[([0-9]*)\]\[BD.*$/\1/g').ass ; done


