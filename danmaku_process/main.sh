#!/bin/bash

#convert xml to ass using Danmaku2Ass
xmls=(); for i in {1..12}_*; do if [ -s "$i" ] ; then xmls[${i%%_*}]+=$i\ ; fi ; done
for i in ${!xmls[@]}; do 
    # read each part's danmaku file name into array, no need to unset IFS for env cmd
    IFS=' ' read -ra arr <<< "${xmls[i]}"
    ## extract cid from each part
    #for p in ${arr[@]}; do
    #    p=$(echo $p | sed -E 's/^[0-9]*_([0-9]*).*$/\1/g')
    #    echo $p
    #done
    ## sort
    #IFS=$'\n' parts=($(sort -n <<< "${arr[*]}"))
    #unset IFS
    #initially thought using *$p* to match the part 
    
    #use version sort
    IFS=$'\n' parts=($(sort -V <<< "${arr[*]}"))
    unset IFS
    for j in ${!parts[@]}; do
        temp_ass=${parts[j]%_*}.ass
        danmaku2ass -o $temp_ass -s 1920x1080 -fs 50 -a 0.7 -dm 10 -ds 7 -p 100 ${parts[j]}
        shift_ass=${i}_part_$(printf %02d.ass ${j%.ass}) 
        if [ $j -gt 0 ];  then
            if [ -n "$offset" ]; then
                echo "${parts[j]} need shift $offset (positive delay)"
                ffmpeg -v quiet -itsoffset $offset -i $temp_ass -c copy $shift_ass
            fi
        else
            ffmpeg -v quiet -itsoffset -13 -i $temp_ass -c copy $shift_ass
        fi
        rm $temp_ass

        # extract prev part last comments appear time as offset
        offset=$(cat $shift_ass | grep "Dialogue\:" | tail -1 | awk -F "," '{ print $2 }')
    done 
done

#put parts from same episode into same element of array
danmakus=();
for f in {1..12}_*.ass; do     
    if [ -s $f ]; then
        danmakus[${f%%_*}]+=$f\ ;
    fi
done

#merge parts
for i in ${!danmakus[@]}; do
   ./merge_ass.sh -p ${danmakus[i]} 
done

# unify the encoding of subtitle ass utilizing the cycle to rename episode as zero leading
for f in *Freezing*.ass; do iconv -f utf-16 -t utf-8 < "$f" > sub_$(echo "$f" | sed -E 's/^.*Freezing\]\[([0-9]*)\]\[BD.*$/\1/g').ass ; done

# merge begin
for sub in sub_*.ass; do
    index=$(echo $sub | sed -E 's/^sub_([0-9]*).ass$/\1/g')
    danmaku=$index.ass
    # add the input validation check here for now
    if [ -f $danmaku ]; then
        ./merge_ass.sh -s $danmaku $sub
        rm $danmaku $sub
    else
        mv $sub ${sub%%.*}_danmaku.ass 
    fi
done

# burn 
./burn.sh
