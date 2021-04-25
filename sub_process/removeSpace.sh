#!/bin/bash
usage="Usage: $0 [extension1] [extension2] ..."
extensions=
#if [ -z "$@" ]; then 
if [ $# -eq 0 ]; then
    echo $usage
    read -p "apply to all extensions[y/n]" applyToAll
    echo $applyToall
    if [ "$applyToAll" == y ]; then
        extensions=*
    else
        exit
    fi
else
    for ext in "$@"; 
    do
        extensions+="*.${ext} " 
#        echo $extensions
    done
fi
#echo $extensions
#exit
for f in $extensions; do 
    mv "$f" $(echo $f | sed -E 's/ /_/g') 
done
