#! /bin/bash
# get usernoted pid
processid=$(ps aux | grep -m1 usernoted | awk '{ print $2 }')
# get usernote process file location
location=$(lsof -p $processid | awk '{ print $9 }' | grep 'db2/db$' | xargs dirname)
# enter db directory
cd $location
# checkpoint migrate db-wal to db
sqlite3 db 'PRAGMA main.wal_checkpoint;' '.exit'
# copy db to path script location
cp db ~/MacForensics/
# back to script location
cd ~/MacForensics/
# call python script and store message in a variable
OUTPUT=$(python macNotifications.py db output.csv | tail -1)
# construct custom url to be sent to quick paste
str="readlog://"$OUTPUT
# call quick paste using custom url
open "$str"
