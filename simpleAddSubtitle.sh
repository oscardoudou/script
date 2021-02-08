#!/bin/bash
usage="Usage: $0 video_extension sub_extension"
if [ $# -ne 2 ]; then 
    echo $usage
    exit
fi

video_ext=$1
sub_ext=$2
sub_exts=(srt ass ssa)
validSub=false

for i in ${!sub_exts[@]}; do 
   if [ "${sub_exts[i]}" = "$sub_ext" ]; then 
       validSub=true
       break
   fi
done

if [ $validSub = "true" ]; then 
   echo "sub extension is specified as ${sub_exts[i]}"
else
    echo "not valid sub extension for 2nd parameter"
    echo $usage
    exit
fi

#replace all files's space with underscore 
for f in *; do
    mv "$f" $(echo "$f" | sed -E 's/ /_/g')
done

for v in *.${video_ext}; do
    # without map video would lost some audio track, also subtitle won't be picked from 1st input either
    # bc input 0 is hardcoded by only striping one occurrence of .*, it will also matched the lecay _sub.mkv if there is any
    ffmpeg -i "$v" -i ${v%.*}.${sub_ext} -map 0:v -map 0:a -map 1:s:0 -c copy ${v%.*}_sub.mkv
done

