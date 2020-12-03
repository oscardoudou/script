#!/bin/bash
mkvdir="$1"
assdir="$2"
start=$3
end=$4
((lastIndex=end-start))

echo "$mkvdir"
echo "$assdir"
echo "$start"
echo "$end"
echo "$lastIndex"

#mkvdir="[NAOKI-Raws]_銀河英雄伝説_BD-BOX_(BDrip_x264_DTS-HDMA+TrueHD5.1ch_Chap)"
# mkvdir should be space free, so it is cdable
#cd "/Volumes/My Book/$mkvdir"
cd "$mkvdir"
echo "now in $PWD"
#for mkv in *0{41..50}*; do mv "$mkv"  $(echo "$mkv" | sed 's/\ /_/g'); done
eval for mkv in *0\{$start..$end\}*\; 'do 
	new_mkv=$(echo "$mkv" | sed "s/\ /_/g")
	mv "$mkv" "$new_mkv"
	mkvs+=($new_mkv)
	done'
#unnecessary just practive match expression
eval for i in \{0..$lastIndex\}\; 'do echo ${mkvs[i]}; done'

#assdir="[YYDM-11FANS][Legend_of_the_Galactic_Heroes][1-110_外傳_OVA1-3]-05022016"
#cd "/Users/zhangyichi/Downloads/$assdir"
cd "$assdir"
echo "now in $PWD"
eval for ass in *\\\[0\{$start..$end\}\\\]*\;'do 
	new_ass=$(echo "$ass" | sed "s/\ /_/g")
	mv "$ass" "$new_ass"
	asses+=($new_ass)
	done'
#eval for i in \{0..$lastIndex\}\; 'do echo ${asses[i]}; done' 
for i in ${!asses[@]}; do
 echo ${asses[i]}
done

##rename ass with mkv, so that in final ffmpeg loop, we only need to deal with one array and use pattern matching to reference another set of object
#for i in ${!asses[@]}; do
#	 mv "${asses[i]}" "${mkvs[i]%.*}.ass" 
#done
#
#I think it is possible to run ffmpeg without rename ass to same name as mkv, previously it is for debug simplicity, since ls and file output seems alrightthen go with wihtout renaming
for i in ${!mkvs[@]}; do
	#ls -l "$mkvdir/${mkvs[i]}" 
	#ls -l "$assdir/${asses[i]}"
	#ls -l "$assdir/${mkvs[i]%.*}.ass"
	#file "$assdir/${mkvs[i]%.*}.ass"
	#echo "${mkvs[i]%.*}_sub.mkv"
	#ls -l "~/Downloads/${mkvs[i]%.*}_sub.mp4" 
	#file "~/Downloads/${mkvs[i]%.*}_sub.mp4"
	ffmpeg -strict -2 -i "$mkvdir/${mkvs[i]}" -i "$assdir/${asses[i]}" -map 0:v -map 0:a -map 1:s:0 -c copy ~/Downloads/${mkvs[i]%.*}_sub.mkv
done
