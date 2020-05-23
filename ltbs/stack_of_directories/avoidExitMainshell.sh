#!/bin/bash
# test getNdir exceeding check, bc getNdir is a function, wrap in a script to execute in subshell to avoid executing main shell
. pushd
. getNdir.sh
# I personally export DIR_STACK in bash_profile, so this env var is not carried to non-login shell, therefore  no need to set DIR_STACK to empty 
echo "DIR_STACK: $DIR_STACK"
pushd /home
pushd /usr
pushd /bin
# until this point we have startup dir and 3 pushd dir, total 4 dir, index 4 should not found
pushd +4