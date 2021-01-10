#!/bin/bash
usage="Usage: $0 video_extension sub_extension"

if [ -z "$*" ]; then 
    echo $usage
fi

video_ext=$1
sub_ext=$2
#replace all files's space with underscore 
for f in *; do
    mv "$f" $(echo "$f" | sed -E 's/ /_/g')
done

for v in *.${video_ext}; do
    # without map video would lost some audio track, also subtitle won't be picked from 1st input either
    # bc input 0 is hardcoded by only striping one occurrence of .*, it will also matched the lecay _sub.mkv if there is any
    ffmpeg -i "$v" -i ${v%.*}.${sub_ext} -map 0:v -map 0:a -map 1:s:0 -c copy ${v%.*}_sub.mkv
done

