// ==UserScript==
// @name         hupu block
// @namespace    http://tampermonkey.net/
// @version      0.1.1
// @description  block annoying people
// @author       oscardoudou
// @match        *://*.hupu.com/*
// @grant        Izzy
// ==/UserScript==

(function() {
    'use strict';
    //隐藏屏蔽的人的回帖
    const blacklist = ['user1','user2','user3']
    const keywords = ['keyword1', 'keyword2']
    var blocked
    $('.floor').each(function(index,floor){
        for (blocked of blacklist){
            if($(floor).find('.u')[0].innerText === blocked){
                // console.log(floor)
                floor.remove()
                //if you wish to see the effect of blocking, uncomment this line and comment the line above
                //floor[i].style.visibility = 'hidden'
            }
        }
    })
    //隐藏含关键字的帖子
    $('.truetit').each(function(index,post){
        for (blocked of keywords){
           if(post.innerText.indexOf(blocked)!=-1){
               console.log(post)
               post.parentNode.parentNode.remove();
               break;
           }
        }
    })
    //console.log(document.readyState)
})();

//notification need wait for window ready. it loads after floor, as state shown as interactive in prev block
$(window).load(function(){
    var blacklist = ['user1','user2','user3']
    //从通知栏移除屏蔽人的回复
    //console.log(document.readyState)
    var removed = 0
    var blocked
    $('.commonNotificationsInfo').each(function(index,notification){
        for ( blocked of blacklist){
            if($(notification).find('a')[0].innerText === blocked){
                notification.parentNode.removeChild(notification)
                removed+=1
            }
        }
    })
    //修改消息栏小红点未读消息数目
    $('.tip-topBubble.tip-topBubble-1')[0].innerText -= removed
})