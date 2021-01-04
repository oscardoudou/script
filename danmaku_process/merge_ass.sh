#!/bin/bash
usage="Usage: $0 [-p] [-s] ass [ass ...]"
peer_mode=false
scale=false
# colon after option means require ARGUMENT
while getopts ":ps" opt; do
    case $opt in 
        p) 
            peer_mode=true;;
        s)
            scale=true;;
        \?)
            echo $usage
            exit 1;;
    esac
done

shift $((OPTIND-1))
if [ -z "$*" ]; then
    echo "$usage"
fi

base=$1
addon=$2

if [ $peer_mode = "false" ]; then
    # ugh, just keep the final name as this for now, this wont incur changin burn.sh
    merged=${addon%%.*}_danmaku.ass
else
    merged=$(echo $base | sed -E 's/^(.*)_part.*/\1/g' | xargs printf %02d ).ass
fi
# currently this check only handle peer_node merge when this is only one file involved, mixed mode merge is checked outside
if [ -z "$addon" ]; then 
    mv $base $merged
    exit 0
fi

#currently primarily use base's script info
cat $base | sed -n '/\[Script/,/^[[:space:]]$/p' > $merged
#extract style section from base, but exclude the empty line after , head negative not working on mac, hardcode for now
cat $base | sed -n '/\[V/,/\[Events/p' | grep -E Style\|Format >> $merged
#append sustitle/addon file's style at the end of base's style (probably could just grep directly)
if [ $scale = "false" ]; then
    cat $addon | sed -n '/\[V/,/\[Events/p' | grep Style\: >> $merged
else
    cat $addon | sed -n '/\[V/,/\[Events/p' | grep Style\: | awk 'BEGIN{FS=OFS=","}{$3=($3+4)*2; print $0}' >> $merged
fi
#append event section column header
echo -en "\n" >> $merged
cat $base | sed -n '/\[Events/,/Format\:/p' >> $merged

#concat extracted dialogue portions and sort based on start time of event
cat <(sed -n '/\Dialogue/,$p' $base) <(sed -n '/\Dialogue/,$p' $addon) | sort -t , -k 2 >> $merged

if [ $peer_mode = "true" ]; then
    rm $base $addon
fi
