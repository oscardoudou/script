#!/bin/bash
#usage $0 danmaku.ass subtitle.ass
danmaku=$1
subtitle=$2
#make sure both are utf-8 encoded, most likely ass would violate this rule
merged=${subtitle%%.*}_danmaku.ass
#currently primarily use danmaku's script info
cat $danmaku | sed -n '/\[Script/,/^[[:space:]]$/p' > $merged
#extract style section from danmaku, but exclude the empty line after 
cat $danmaku | sed -n '/\[V/,/^[[:space:]]$/{/^[[:space:]]$/!p;}' >> $merged
#append sustitle file's style at the end of danmaku's style (probably could just grep directly)
cat $subtitle | sed -n '/\[Script/,/\[Events/p' | grep Style\: | awk 'BEGIN{FS=OFS=","}{$3=($3+4)*2; print $0}' >> $merged
#append event section column header
echo -en "\n" >> $merged
cat $danmaku | sed -n '/\[Events/,/Format\:/p' >> $merged
#concat extracted dialogue portions and sort based on start time of event
cat <(sed -n '/\Dialogue/,$p' $danmaku) <(sed -n '/\Dialogue/,$p' $subtitle) | sort -t , -k 2 >> $merged
