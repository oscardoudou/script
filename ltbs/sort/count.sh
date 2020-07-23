#!/bin/bash
# 2  3  8  7  1  2  2  2  7  3  9  8  2  1  4  2  4  6  9  2
set -o xtrace
nums=(2  3  8  7  1  2  2  2  7  3  9  8  2  1  4  2  4  6  9  2)
let count=()
for((i = 0 ; i < ${#nums[@]}; i++)); do
    ((count[${nums[i]}]++))
done
# for((i = 0 ; i < ${#count[@]}; i++)); do
#     echo "$i -> ${count[i]}"
# done

for((i = 0, j = 0 ; i < ${#count[@]}; i++)); do
    while [ ${count[i]} -gt 0 ]; do 
        nums[$j]=$i
        ((count[$i]--))
    done
done
for((i = 0; i < ${#nums[@]}; i++)); do
    echo -n ${nums[i]}
done
set +o xtrace
