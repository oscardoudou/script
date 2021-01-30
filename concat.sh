#!/bin/bash
#usage="$0 start end dest"
if [ ${#@} -ne 3 ]; then 
        echo $usage
            exit
fi
start=${1:-required}
end=${2:-required}
#no need to escape space here, as in file.txt path is single qutoed
src="/Volumes/NO NAME/DCIM/105UNSVD"
dest=${3:-required}
echo "prepare the concat file"
timestamp=$(date)
comment="# ${timestamp} concat"
echo $comment > file.txt
#eval benifits us with option of variable inside curly bracket
#yet also introduce the difficulty to simply echo single inside
#double
eval for i in \{$start..$end\} '
do
    formatNumber=$(printf %04d $i)
    filename="GRMN${formatNumber}.MP4"
    #use printf seems much easier
    echo file ${src}/${filename} >> temp.txt
done'
#can't direct echo single quote in loop above
cat temp.txt | sed -E "s/^file\ (.*)$/file \'\1\'/g" >> file.txt
rm temp.txt
cat file.txt
ffmpeg -f concat -safe 0 -i file.txt -c:v copy -c:a aac "${HOME}/Downloads/${dest} ${timestamp}.MP4"
echo "concated video as ${HOME}/Downloads/${dest} ${timestamp}.mp4"
