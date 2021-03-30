# 
#   use name of mkv files in one directory  
#   to rename ass files in another directory
#   though it claims to be able to rename files using files in another file, but doesn't seem to be
#   quickly make it work, currently only support ./rename . .
dir1=$1
dir2=$2
#   if directory contains character need to escape
#   most likely can't simply do ass=(dir1/*.mkv)
#   hardcode dir1 if necessary 
#   put all video files into an array
mkvpaths=($dir1/*.mkv)
#echo $dir1
#echo ${#mkvpaths[@]}
#echo ${mkvpaths[10]##*/}
##   strip leading path components
#mkvfiles=("${mkvpaths[@]##*/}")
#ehco ${mkvfiles[10]}
#exit
##   strip extension
#names=("${mkvfiles[@]%.*}")
#   put all asspath into an array
asspaths=($dir2/*.ass)
##   strip leading path components
#assfiles=("${asspaths[@]##*/}")
##   loop through index in the list of array indexes
for i in ${!asspaths[@]}
do
    #   rename the ass with name of mkv with same index from names array
    name=${mkvpaths[i]##*/}
    #echo name $name 
    #echo ass ${asspaths[i]##*/}
    #echo ${name%.*} 
    #mv "${assfiles[i]##*/}" "${names[i]}".ass
    mv ${asspaths[i]##*/}   ${name%.*}.ass
done
