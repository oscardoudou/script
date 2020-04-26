#! /bin/bash
str=`cat $1`
#echo with double quote give file with line break
echo "$str"
while IFS='$2' read -r -a chunk ; do
for i in "${chunk[@]}" ; do
#  echo "${chunk[$i]}"
echo $i
done
done <<< $str
