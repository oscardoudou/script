#!/bin/bash
# get Nth(starting at 0) directory from stack
# /home /usr /bin getNdir +1 should get /usr

function getNdir () {
    stackfront=''
    let count=0
    while [ $count -le $1 ]; do
        #temporary strip left of DIR_STACK to remove first directory give us rest of DIR_STACK with no leading space, 
        #then strip right of DIR_STACK with rest of direcotry without leading space, now we end up with a first directory with trailing space
        #why dont simply use "${DIR_STACK%% *} " 
        target=${DIR_STACK%${DIR_STACK#* }}
        #why not ${DIR_STACK#* } exactly part of first step
        DIR_STACK=${DIR_STACK#$target}
        stackfront="$stackfront$target"
        let count=count+1
    done
    stackfront=${stackfront%$target}
} 