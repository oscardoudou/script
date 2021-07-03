#!/bin/bash
function log(){
    var=$1
    echo "$var = ${!var}"
}

function isValidExtension(){
    local e match="$1"
    shift
    #for without in with iterate over argument list, thanks for shift above, it will take original argument starting position 2
    for e; do 
        if [ "$e" = "$match" ]; then
            log match
            log e
            return 0
        fi
    done
    return 1
}


ext=${1:?"required"}
validExt=(mkv mp4)
baseEpisode=${2:?"required"}
isValidExtension "$ext" "${validExt[@]}"
# if retun 0 meaning isValidExtension, we continue
if [ $? = 0 ]; then 
    echo "$ext is a valid extension" 
else 
    echo "$ext is not valid extension"
    exit 1
fi
regex="*.${ext}"
# echo $regex here still would give you the all expanded result but it is stored in a plain variable, 
# we still need to put it in an array to be able index the element

# working dir is inside a season folder
season=${PWD##*/}
seriesSeason=${PWD#*TV\ Shows/}
#series=${seriesSeason%/Season\ 1}
#series=${seriesSeason%/"Season 1"}
#series=${seriesSeason%/"$season"}
series=${seriesSeason%/$season}
log series
log season

#if season folder named with leading 0, then we could save this hassle
#season=$(printf %02d ${season#*\ })
season=${season#*\ }
log season

#set print format based on total video cnt in curr dir, default to %02d
episodes=($regex)
episodeCnt=${#episodes[@]}
digit=${#episodeCnt}
if [ $digit -le 2 ]; then 
    digit=2
fi
format="%0${digit}d"
log format

for i in ${!episodes[@]}; do
    echo ${episodes[i]} | tee -a episodes.txt
    episode="${series} - S${season}E$(printf $format $((baseEpisode+i))).${ext}"
    log episode
    mv "${episodes[i]}" "$episode"
done


