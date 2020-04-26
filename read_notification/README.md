Log mac notification and further automation
=========
## Why doing this?
I have some online accounts signed up using email only. I am not a big fan of associating the account with 
google, facebook and github account. I think there is some privacy issue there. So I tend to use email. 
But the cons is some of them dont support password when you are using email. Everytime you login, you have to input 
the stupid login code they send to you. You will be like: 
1. switch out what ever desktop app or web app you were on to mail or imessage (Command+Tab/click the notification)
2. select the code and copy it (more mouse and Command+C) 
3. go bakc to original app (Command+Tab)
4. paste it and click login (Command+V and click)

Seems too much steps, but thess are exactly the minial step you need to take. Someone may say, apple support automated populate verification code
to text box. But up to this point, that feature limits to safari while the verification is done by imessage. There is lots of apps out 
there not using text message but email. Also chrome seems to be the most popular browser. So the hassle does exist.

## Initial thought
Retrieving actual messages or log wherever the notifications center store files and parse them

It turns out. Notifaction center doesn't have a place to store them. And there is no log of notification in console. The content is visible 
in log only when using osascript to simulate the notification.