#!/bin/bash
read -a nums -p "input list of number:"
for (( i=0; i < ${#nums[@]}; i++ )); do
    lowest=$i
    for(( j=i+1 ; j < ${#nums[@]}; j++)); do 
        if [ ${nums[j]} -lt ${nums[lowest]} ]; then
            #only keep track of index, instead of swap every comparison
            lowest=$j
        fi
    done
    temp=${nums[i]}
    nums[i]=${nums[lowest]}
    nums[lowest]=$temp
done

echo ${nums[@]}