#!/bin/bash
function getIndexCollectionsOfUser(){
    local user=$1   
    user=${user:?required} 
    #replace below with the curl command of the call executed when click on XXX收藏的目录 of http://bangumi.tv/user/XXX/index maingly need the auth
    #command after pipe is jq like utility but for html, here is used to extract the indexes user XXX collect on http://bangumi.tv/user/XXX/index/collect 
    curl "https://bangumi.tv/user/${user}/index/collect"   -H 'Connection: keep-alive'   -H 'sec-ch-ua: "Chromium";v="88", "Google Chrome";v="88", ";Not A Brand";v="99"'   -H 'sec-ch-ua-mobile: ?0'   -H 'Upgrade-Insecure-Requests: 1'   -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 11_1_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.192 Safari/537.36'   -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'   -H 'Sec-Fetch-Site: same-origin'   -H 'Sec-Fetch-Mode: navigate'   -H 'Sec-Fetch-User: ?1'   -H 'Sec-Fetch-Dest: document'   -H 'Referer: https://bangumi.tv/user/ychz/index/collect'   -H 'Accept-Language: en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7'   -H 'Cookie: __utmc=1; __utmz=1.1614401121.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); chii_cookietime=2592000; chii_auth=UqYRJYQLt8BG1dRu%2BFwPEYfIjC4swztECoAdbSa5v7AX2AQGZjaZdoU8z0iOAI2n4555DZ11VuKqxxaOdakRUKG49nsVNcDNb%2BDU; chii_searchDateLine=0; chii_theme=light; __utma=1.875808124.1614401121.1614485377.1614527691.10; __utmt=1; chii_sid=kjgKKV; __utmb=1.43.10.1614527691'   --compressed | pup '.info.clearit h3 a text{}' 
}

main(){
    local idle=$1
    idle=${idle:?required}
    chromePath="/Users/zhangyichi/Library/Application Support/Google/Chrome"
    ls -l "$chromePath"
    chromeDebugLog=${chromePath}/chrome_debug.log
    ls -l "$chromeDebugLog"
    #get the current timestamp prior to run any js in chrome console
    start=$(date "+%m%d/%H%M%S")
    echo "start time: $start"
    #make sure run js within this idle 15 seconds, 1st parameterized option
    sleep $idle
    #extract the log using awk, in awk we can't pass the date command directly, bc that would be newer than timestamp in log
    #tail "$chromeDebugLog" | awk -F':' -v timestamp=$start' { print $3,timestamp  }' #fail to figure out how to use tail, it always return last 10 lines
    #extract the log that is newer than timestamp and also belongs to certain user script, 2nd paramterized option replace find.*subscriber with the name of your user script, replace space with .*
    #lastly just a simple extraction of userId from each link
    array=($(cat "$chromeDebugLog"| awk -F":" -v timestamp=$start '{ if($3>timestamp".000000") print  }' | grep "find.*subscriber" | sed -E 's/^\[.*bangumi.tv\/user\/(.*)\".*$/\1/g'))
    echo ${#array[@]}
    echo ${array[@]}
    for i in ${!array[@]}; do
        echo "========user ${array[i]}========"
        getIndexCollectionsOfUser "${array[i]}"
    done
}

main "$@"
