#! /bin/bash
# input are multiple line of two single quoted date separated by comma 
# '2019-02-25', '2019-02-28',
# '2019-02-01', '2019-02-04',
# 1st argument is the amount of day you want to shift
# 2nd argument is to indicate shift direction b stand for backwards, otherwise means forward
amount=$1
direction=$2
[[ "$direction" = "b" ]] && direction="ago" || direction=""
echo "shift $amount day $direction"
sed -i "s/'//g" datePairs.txt 
cp /dev/null modified.txt
while read -r line || [[ -n "$line" ]]
do 
IFS=',' read -r -a pair <<< "$line"
    # it seems IFS won't bring in empty , so no need loop except last elelment below
    # echo "array pair size: ${#pair[@]}"
    modified_pair=""
    for d in "${pair[@]}"
    do 
        d1=$(date -d "$d $amount day $direction" +%Y-%m-%d)
        modified_pair+="'$d1', "
    done
    echo $modified_pair >> modified.txt
# shift date pairs by given amount of days
done < datePairs.txt
# for linux copy
xclip -selection clipboard modified.txt