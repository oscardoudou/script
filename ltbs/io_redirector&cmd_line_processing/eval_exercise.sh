#!/bin//bash
# chapter 7 exercise
# most eval example in this chapter is to solve pipe uncovered after parameter and pathname expansion
# this example is similar thought as above, brace expansion is before parameter expansion, 
# so by the time $num evaluated as 4, {} won't be further interpreted as it passed the time should be processed, eval give it 2nd chance
# eval echo {1..num} or eval echo "{1..num}", no matter having double quotes or not, $num would be expanded at first round, and at 2nd round, 
# brace expansion with concrete value, {1..4} would be expaned 
num=4
echo {1..$num}
eval echo "{1..$num}"

# 3.a
object=person
person=alice
eval echo \$$object

# 3.b
# P122 P128
# shell's standard for loop doesn't let you specify a number of times to iterate or a range of values over which to iterate;
# instead, it only lets you give a fixed list of values. 

# https://stackoverflow.com/questions/9337489/brace-expansion-with-a-bash-variable-0-foo
# this post enlight me you need double quote, but confused why have to use arithemetic expansion when simple parameter could resolve

# standard for loop iterated over specified range
# double quote skip brace expansion all the way to paramter expansion
# it seems effort of double quote skip make specifying range in standard for loop possible, however without eval, double quote has no chane of using
iterations=5
eval  "for i in {1..$iterations}; do echo do something; done"

# arithmetic for loop iterated over specified range
# I didn't see why we need eval as paramter expansion first then arithmetic expansion, see next example 
# $i should be put off until next round, otherwise it would be empty
unset i
eval "for((i=1; i<$iterations; i++))
    do
        echo $i
    done"
# aka c style loop, $ inside parenthesis is not needed, page
# https://stackoverflow.com/questions/169511/how-do-i-iterate-over-a-range-of-numbers-defined-by-variables-in-bash/5723526#comment108923169_5723526
for((i=1; i<iterations; i++))
do
    echo $i
done