#!/bin/bash
# simply run crop under the directory of png you want to crop
# crop youtube screenshot
# using glob without passing to ls, store the output in array
arr=(*)
for i in ${!arr[@]}; do 
    mv "${arr[i]}" $((++i)).png 
done
for file in *; do
    pnm=${file%.png}.pnm
    pngtopnm $file > $pnm
    pnmcut -cropbottom 180 -croptop 180 $pnm | pnmtopng > ${file%.png}_cut.png
done
