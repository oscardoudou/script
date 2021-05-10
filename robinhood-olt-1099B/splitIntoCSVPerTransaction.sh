#!/bin/bash
processedFile="$1"
processedFile=${processedFile:?"required"}
i=1 
mkdir -p transactions
while read line; do 
    formatNumber=$(printf %03d $i)
    echo "$line" > transactions/$formatNumber.csv  
    ((i++))
done < "$processedFile"
