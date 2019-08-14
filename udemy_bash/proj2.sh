#! /bin/bash
# copy all hot articles with appened match line number to another directory with same structure
# takeout
# 1. cp command doesn't have option to create intermediate necessary folder 
# 1' instead of check folder existence using test with -d -e, simply use mkdir -p
# 2. for the file iterating in certain relative path, the iterating element would contain the relative path as well
# 2' eg. for file in folder1/* , all $file would have a leading folder1/ in their name folder1/foo, folder1/bar etc
# 3. avoid introduce "." in filename, simply use * in your entry loop, namely for file in * , instead of for file in ./*
# 3' add a sanity check at entry of script so you wont mess up the filename you are iterating, see line 14
search(){
    local curdir=$1
    echo $curdir
    local keyword=$2
    if [ $curdir == "." ]; then
        # curdir="." 
        allincur="*" 
    else
        allincur="$curdir/*"  
    fi
    for file in $allincur
    do
        # echo $file
        if [ -f "$file" ]; then
            if [[ $(grep -n "$keyword" "$file") ]]; then
                    mkdir -p "report/$curdir"
                    if [ ! -e "report/$file" ]; then 
                        cp $file report/$file
                        echo -e "\n" >> report/$file
                    fi
                    grep -n "$keyword" "$file" >> report/$file
            fi
        else
            # ignore report/ folder itself
            if [ "$file" != "report" ]; then
                echo "$file is a directory, entering $file..."
                #update the curdir with the directory name iterating now
                curdir=$file
                search $curdir $keyword
            fi
        fi      
    done
    
}

read -p "number of keywords: " num
mkdir -p report
word=()
for ((i=1;i<=num;i++))
do
    read -p "keyword$i: " word[$i]
done


for ((i=1;i<=num;i++))  
do  
    echo "******************"
    echo "searching keyword$i ${word[$i]}"
    search . ${word[$i]}
    echo "******************"
done