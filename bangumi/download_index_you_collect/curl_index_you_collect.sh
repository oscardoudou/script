curl 'https://bangumi.tv/user/ychz/index/collect' \
  --compressed \
  |  pup '.info.clearit h3 json{}' | jq '.[].children[0]  | "bangumi.tv\( .href) \(.text)"' | tr -d '"' | sed -E 's/\ /\n/'
