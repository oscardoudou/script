Too stubborn to use selenium, instead output log of chrome and wrangling it
============
I wrote some naive scripts using selenium before, it isn't much of joy when you finish your selenium script. Until now, everytime I a solution for automation comes up involves using selenium, I feel bad about myself. Simply bc I think there always should be a more native way of solving it. This ideaology probably would hold true throughout my junior developer career.

## Inspiration
You came up with some quick and dirty userscript that lives in your chrome console. At that moment, this probably gonna be your next naive user script. Later, you realize that you need the output of chrome console to be the input of your bash script. What should you do?
(Below works only for mac)

### Access you chrome log file
this will run chrome with your user data, all your bookmark, password and extension remain. All make it easier.

```/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir='/Users/XXX/Library/Application Support/Google/Chrome' --enable-logging --v=1```

### Extract info from your log file
Depends on where you specify your --user-data-dir, you chrome_debug.log might be different.
If you use default --user-data-dir of yourself, then your log file is located at
`/Users/XXX/Library/Application Support/Google/Chrome`

Supposedly you should use tail along with awk to wrangling your info in log.
So far can't quite figure out how tail should be used, as it always returns 10 lines. For now using cat.

```cat "$chromeDebugLog"| awk -F":" -v timestamp=$start '{ if($3>timestamp".000000") print  }' | grep "userscript.*name"```

Above does 3 things:
1. read your log file
2. extract log that is only newer than certain timestamp
3. grep log from specific user script only 

1 2 should be self-explained, 3 need to pay attentin, as chrome output %2520 as space, so grep it simply replace all the space in the name of your userscript

## Specific use case
### Who favorite your index(谁收藏了你的目录)
1. mainly consist of extract user name as an array
2. curl that user's index/collects page using the credential from chrome


