#!/bin/bash
usage="Usage: $0 subExtension (+/-)offset"
if [ $# -ne 2 ]; then
    echo $usage
    exit
fi
subExt=$1
offset=$2
for sub in *.${subExt} ; do 
    ffmpeg -itsoffset $offset -i "$sub" -c copy ${sub%.*}_shift.ass 
done
