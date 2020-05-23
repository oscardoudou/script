#!/bin/bash
# builtin dirs +n -l, not consider both -l +n case, getopts would be to cumbersome

usage="Usage: dirs [+n] [-l]" 
function dirs () {
    # case dir +n
    if [ $(echo $1 | grep '^+[0-9][0-9]*$') ]; then
        num=${1#+}
        let count=0
        dirstack="$DIR_STACK"
        # unlike multiple condition in one test below, this would fail while condition if DIR_STACK is empty 
        while [ -n "$dirstack" ] && [ $count -le $1 ]; do
            ndir=${dirstack%% *}
            dirstack=${dirstack#* }
            let count=count+1
        done
        # add check for N exceeding number of directories in DIR_STACK, 
        # check stack empty as well as whether above loop iteration times - 1 equals param, if equals then it happen to get last dir in stack, otherwise param exceeding stack depth 
        if [ -z "$dirstack" -a $((count-1)) -ne "$1" ]; then
            echo "DIR_STACK has no ${num}th directory"
            # for function would directly called from shell, be careful on exit
            exit 1
        else
            echo "${num}th directory: $ndir"
        fi
    # when using posix compatible single bracket, remember to quote variable to avoid unary operator expected when variable is empty or undefined
    elif [ "$1" = "-l" ]; then
        dirstack="$DIR_STACK"
        while [ -n "$dirstack" ]; do
            ndir=${dirstack%% *}
            dirstack=${dirstack#* }
            #-d Directories are listed as plain files (not searched recursively). 
            # tilde in DIR_STACK is automatically replaced by ls -ld, should use string substitution if not available
            ls -ld $ndir
        done
    elif [ -z "$1" ]; then
        echo $DIR_STACK
    else 
        echo $usage
    fi
}