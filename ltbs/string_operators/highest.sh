#   TASK 4-1
#   highest filename [lines_to_show]
#   
#   print top lines_to_show lines in file filename
#   Assuming input file have lines that start with number
#   By default show top 3 lines

filename=$1
if [ -z $filename ]; then 
    #   use single quote here, as there is no variable nor command substitution in this string
    #   recall "When in doubt, use single quote" has been revised several times
    echo 'usage: ./highest.sh filenmae [-N]'
    exit 1
fi
lines_to_show=${2:--3}
#   option n tells sort to interpret the first work on each line as number rather than a character string
sort -nr $filename | head $lines_to_show
