#!/bin/bash
for mkv in *.mkv; do
    mv "$mkv" $(echo "$mkv" | sed -E 's/\ /_/g')
done
mkvs=(*.mkv)
asses=(*danmaku.ass)
for i in ${!mkvs[@]}; do 
    ffmpeg -i "${mkvs[i]}" -i ${asses[i]} -c copy ${mkvs[i]%.*}_sub_danmaku.mkv
done
