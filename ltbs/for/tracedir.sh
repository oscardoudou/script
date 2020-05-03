#!/bin/bash
# print all directories below a give one with structure
# my solution took more cycle on setting up tab spaing, will become more expensive when have deeper file structure
# it only takes one argument
# tracdeir ltbs under script directory 
function tracedir () {
    # see below why this is local
    local file=$1
    tabcount=${tabcount:-0}
    # for i in {1..$tabcount} brace expansion doesn't work with var, bc it is before parameter expansion
    # for i in $(seq 1 $tabcount) this would produce 1 0, when tabcount is 0. Not similar as c for loop, plus this call a subprocess 
    # reason tabcount doesn't need $ before, same reason as i not use. 'Within an expression, shell variables may also be referenced by name without using the parameter expansion syntax'
    for ((i=0; i<tabcount; i++)) 
    do  
        echo -en "\t"
    done    
    echo -e "$file"
    if [ -d "$file" ]; then 
        # echo "$file is directory, cd to $file"
        cd $file
        tabcount=$((tabcount+1))
        # echo $PWD
        for f in $(ls .)
        do
            tracedir "$f"
        done
        tabcount=$((tabcount-1))
        # this line has a problem if var file is global, it doesn't print directory it cd back to
        # rather last non-dir file in recent tracedir
        # echo "cd back to $file"
        cd ..
    fi
}
