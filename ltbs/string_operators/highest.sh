#   TASK 4-1
#   highest filename [lines_to_show]
#   
#   print top lines_to_show lines in file filename
#   Assuming input file have lines that start with number
#   By default show top 3 lines

filename=$1
lines_to_show=$2
header=$3
echo -e -n ${header:+"ALBUMS   ARTIST\n"}
sort -r ${filename:?"is required"} | head -${lines_to_show:=3}
