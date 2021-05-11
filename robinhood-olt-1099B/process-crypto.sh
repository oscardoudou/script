#!/bin/bash
raw_csv="$1"

#get minimum working part of csv
startLine=$(cat "$raw_csv" | grep -n -m 1 'DateSold' | cut -d':' -f1)
endLine=$(cat "$raw_csv"  | grep -n 'Security Totals' | cut -d':' -f1)

#extract 
sed -n "${startLine},${endLine}p" "$raw_csv"  > matters-crypto.csv

#remove non transaction related line(either don't have date or dont mention company)
#remove repetitived commany line(trailing with cont'd)
#remove table(with continued) name line
#bc using grep, strip the file source in this case standard input, notice - after column2 to remove column1 only
#reverse the file (bottom up), prepare for population the missing selling date for some row
cat matters-crypto.csv |
    grep -irE '(0?[0-9]|1[012])\/(0[0-9]|[12]\d|3[012])\/20'\|CUSIP\:.*Symbol |
    grep -v "Symbol: (cont'd)" |
    grep -v "(continued)" |
    cut -d':' -f2- |
    tac  > reverse-crypto.csv

#inplace remove the double quote, prepare for manipulating the 1st column of some row
sed -i.bak -E 's/\"(.*)\"/\1/g' reverse-crypto.csv

#add crypto name as company to column 1, though being treated as single column, but would be split into right amount when js processing
#add placeholder for column1f1g
#reverse it back, though there is no reason to reverse when processing crypto in the first place, but to keep majority code similar to process.sh, we keep reverse(tac) step before and here
cat reverse-crypto.csv | awk '{ $1="BTCUSD " $1 ;  $6="..." ; NF=6; print  }' | tac
