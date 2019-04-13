# contains only lowercase characters and space ' ' characters
# Read from the file words.txt and output the word frequency list to stdout.
tr -s "[:blank:]" "[\n*]" < test.txt | sort | uniq -c | sort -r | awk '{ print $2,$1}'