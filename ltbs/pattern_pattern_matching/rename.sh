#!/bin/bash
#   use name of video files in one directory  
#   to rename sub files in another directory
#   though it claims to be able to rename files using files in another file, it doesn't seem to be as of last attempt
#   right now to quickly make it work, currently only support ./rename videoExt subExt. .
videoExt=$1
subExt=$2
dir1=${3:-.}
dir2=${4:-.}
#   if directory contains character need to escape
#   most likely can't simply do subpaths=(dir1/*.$videoExt)
#   put all video files into an array
videopaths=($dir1/*.$videoExt)
#    put all subpath into an array
subpaths=($dir2/*.$subExt)
#   loop through index in the list of array indexes
for i in ${!subpaths[@]}
do
    #   rename the sub with name of video with same index from names array
    name=${videopaths[i]##*/}
    mv ${subpaths[i]##*/}   "${name%.*}.${subExt}"
done
