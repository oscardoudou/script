#!/bin/bash
#   use name of video files in one directory  
#   to rename sub files in another directory
#   though it claims to be able to rename files using files in another file, it doesn't seem to be as of last attempt
#   right now to quickly make it work, currently only support ./rename videoExt subExt. .
usage="Usage: $0 videoExt subExt [videoFolder] [subFolder]"
if [ -z "$1" ]; then
    echo $usage
    exit 1
fi
videoExt=$1
subExt=$2
dir1=${3:-.}
dir2=${4:-.}
#   if directory contains character need to escape
#   most likely can't simply do subpaths=(dir1/*.$videoExt)
#   put all video files into an array
videopaths=($dir1/*.$videoExt)
echo ${videopaths[0]}
echo ${videopaths[1]}
#    put all subpath into an array
subpaths=($dir2/*.$subExt)
echo ${subpaths[0]}
echo ${subpaths[1]}
#   loop through index in the list of array indexes
for i in ${!subpaths[@]}
do
    #   rename the sub with name of video with same index from names array
    name=${videopaths[i]##*/}
    echo ${subpaths[i]##*/}
    echo "${name%.*}.${subExt}"
    mv ${subpaths[i]##*/}   "${name%.*}.${subExt}"
done
