#!/bin/bash
# get Nth(starting at 0) directory from stack
# /home /usr /bin getNdir +1 should get /usr
# v1 without exceeding check, pushd will end up unchanged bc stackfront has all dir DIR_STACK previously store and target it empty, so it looks fine.
# v2 check for N exceeding number of dir in stack and exit if true, see avoidExitMainshell.sh 
function getNdir () {
    stackfront=''
    let count=0
    while [ $count -le $1 ] && [ -n "$DIR_STACK" ]; do
        #temporary strip left of DIR_STACK to remove first directory give us rest of DIR_STACK with no leading space, 
        #then strip right of DIR_STACK with rest of direcotry without leading space, now we end up with a first directory with trailing space
        #why dont simply use "${DIR_STACK%% *} " 
        target=${DIR_STACK%${DIR_STACK#* }}
        #why not ${DIR_STACK#* } exactly part of first step
        DIR_STACK=${DIR_STACK#$target}
        stackfront="$stackfront$target"
        let count=count+1
    done
    if [ $((count-1)) -ne $1 ]; then
        echo "index $1 out of range, number of dir in DIR_STACK: $((count)) (first dir is index 0)"
        DIR_STACK="$stackfront"
        echo "DIR_STACK: $DIR_STACK"
        exit 1
    fi
    stackfront=${stackfront%$target}
} 