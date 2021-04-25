#!/bin/bash
currRepo=${PWD##*/}
echo "current repo: $currRepo" 
# safe to check if it is directory, as PWD wont store a path to a regular file
if [ -d $1/$currRepo ]; then
  echo "backup destination $1/$currRepo already exists"
  cmd="rm -rf $1/$currRepo"
  read -p "wanna run $cmd? (y): " confirm && [[ $confirm == [y] ]] || exit 1
  echo $confirm
  if [ $confirm = "y" ]; then
    eval "$cmd"
  else
    echo "quit backup"
    exit 1
  fi
fi
# after above deletion of the destination, now make sure the destination folder not exist anymore
if [ ! -d $1/$currRepo ]; then
  cp -r ../$currRepo $1
  ls -ld $1/$currRepo 
fi
