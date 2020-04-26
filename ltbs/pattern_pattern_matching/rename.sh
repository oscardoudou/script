# 
#   use name of mkv files in one directory  
#   to rename ass files in another directory

dir1=$1
dir2=$2
#   if directory contains character need to escape
#   most likely can't simply do ass=(dir1/*.mkv)
#   hardcode dir1 if necessary 
#   put all video files into an array
mkvpaths=(dir1/*.mkv)
#   strip leading path components
mkvfiles=("${mkvpaths[@]##*/}")
#   strip extension
names=("${mkvfiles[@]%.*}")
#   put all asspath into an array
asspaths=(dir2/*.ass)
#   strip leading path components
assfiles=("${asspaths[@]##*/}")
#   loop through index in the list of array indexes
for i in ${!assfiles[@]}
do
    #   rename the ass with name of mkv with same index from names array
    mv "${assfiles[i]}" "${names[i]}".ass
done
