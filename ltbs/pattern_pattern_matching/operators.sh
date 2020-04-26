#
#   continue with string operators
#   play with pattern-matching operators
#   mnenomic tip regarding number sign and percent sign
#   on keyboard # $ % is arranged like # is at the beginning while % is in the end
path=$(pwd)
echo ${path##/*/}
echo ${path#/*/}
echo ${path}
echo ${path%pattern_*}
echo ${path%%pattern_*}