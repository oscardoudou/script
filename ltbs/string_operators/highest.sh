#   TASK 4-1
#   unix like option before argument
#   highest [lines_to_show] filename
#   
#   print top lines_to_show lines in file filename
#   Assuming input file have lines that start with number
#   By default show top 3 lines

# using pipe inside command substitution let double quote become mandatory
if [ -n "$(echo $1 | grep -irE '^-[0-9]+$')" ]; then 
    lines_to_show=$1
    shift
elif [ -n "$(echo $1 | grep -irE '^-.*')" ]; then
    #   use single quote here, as there is no variable nor command substitution in this string
    #   recall "When in doubt, use single quote" has been revised several times
    echo 'usage: ./highest.sh [-N] filename'
    exit 1
else 
    lines_to_show="-3"
fi
filename=$1
#   option n tells sort to interpret the first work on each line as number rather than a character string
sort -nr $filename | head $lines_to_show
