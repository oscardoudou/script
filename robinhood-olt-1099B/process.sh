#!/bin/bash
raw_csv="$1"

#get minimum working part of csv
startLine=$(cat "$raw_csv" | grep -n -m 1 'Description of property' | cut -d':' -f1)
endLine=$(cat "$raw_csv"  | grep -n 'Detail for Dividends' | cut -d':' -f1)

#extract 
sed -n "${startLine},${endLine}p" "$raw_csv"  > matters.csv

#remove non transaction related line(either don't have date or dont mention company)
#remove repetitived commany line(trailing with cont'd)
#remove table(with continued) name line
#bc using grep, strip the file source in this case standard input, notice - after column2 to remove column1 only
#reverse the file (bottom up), prepare for population the missing selling date for some row
cat matters.csv |
    grep -irE '(0?[0-9]|1[012])\/(0[0-9]|[12]\d|3[012])\/20'\|CUSIP\:.*Symbol |
    grep -v "Symbol: (cont'd)" |
    grep -v "(continued)" |
    cut -d':' -f2- |
    tac  > reverse.csv

#fail to use sed, \d may not be recongized 
#sed -E "/(0?[0-9]|1[012])\/(0[0-9]|[12]\d|3[012])\/20|CUSIP\:.*Symbol)/!d" matters.csv

#inplace remove the double quote, prepare for manipulating the 1st column of some row
sed -i.bak -E 's/\"(.*)\"/\1/g' reverse.csv

#add missing selling date based on summary transaction 
#reverse the file back to original order
#remove line containg reported to the IRS 
#remove line contains Total of X transactions
#remove company line having trailing comma
awk 'BEGIN {company=$1; date=$1}
{ if($0 ~ /^.*CUSIP.*$/) { company=$1; print company }
else if($1 ~ /(0?[0-9]|1[012])\/(0[0-9]|[12][0-9]|3[01])\/20/) {date=$1; $1=date; print $0}
 else {$1=date" "$1; print $0} }' reverse.csv  |
 tac |
sed  '/reported to the IRS/d' |
sed '/Total of.*transaction/d' |
sed -E 's/^(.*),$/\1/g' > intermediate.csv

#convertio convert 1f&1g column of proceeds table in pdg into two separated columns in csv
#since I only have wash sale code presnet in this column and it doesn't need to fill in gain loss yourself in 1099-B form, we make it simple cut remove all the columns afterwards
#add company column to each transaction for easy digestion(if first column doesn't contains current year 2 digits, then it is a company row)
cat intermediate.csv |
    awk 'NF=6' |
    awk 'BEGIN {company=$1} {if($1 !~ 20 ){company=$1} else {$1=company" "$1; print $0}}'
