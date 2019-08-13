#! /bin/bash
# find article in a folder which contains keywords and copy those articles
# to another place and mark the line keywords present at the end of file

read -p "number of keywords: " num
mkdir report
word=()
for ((i=1;i<=num;i++))
do
    read -p "keyword$i: " word[$i]
done

for ((i=1;i<=num;i++))  
do  
    echo "******************"
    echo "searching keyword$i ${word[$i]}"
    for j in *
    do
        # echo $j 
        if [ -f "$j" ]; then
            # success try 1
            if [[ $(grep -n ${word[$i]} $j) ]]; then
            # # success try 2
            # # test if grep output is empty string
            # output="$(grep -n ${word[$i]} $j)"
            # echo "$output"
            # if [ -n "$output" ]; then 
            # # success try 0
            # keyword=${word[$i]}
            # # echo $keyword
            # if [[ $(grep -n $keyword $j) ]]; then 
                if [ ! -e report/$j ]; then
                    cp $j report/$j
                    echo -e "\n" >> report/$j
                fi
                grep -n ${word[$i]} $j >> report/$j
            fi
        else 
            echo "$j is not a regular file"
        fi 
    done
    echo "******************"
done

            # fail try 0: instead of specify the destination in grep, cd the direcotry and use the same file name during the loop 
            # subprocess, directory changed after cd, combine command to stay at the directory just changed
            # output=$(grep -nH ${word[$i]} ${j})
            # if [ $? -eq 0 ]; then
            #     cd ~/Downloads  
            #     if [ ! -e $j ]; then
            #         cp "/Users/zhangyichi/Documents/519/"$j ~/Downloads
            #     fi 
            #     echo $output >> $j
            # fi