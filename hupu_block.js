// ==UserScript==
// @name         hupu block
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  block annoying people
// @author       oscardoudou
// @match        https://bbs.hupu.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    //隐藏屏蔽的人的回帖
    //no need to chain the class, continue use the dom element to find
    //var $users = $('.floor .floor-show .floor_box .author .left .u')
    var blocklist = ['user1','user2']
    var blocked
    $('.floor').each(function(index,floor){
        //console.log($users[i])
        //user[i] doesn't match index of $floor[i]
        for (blocked of blocklist){
            //use $ wrap the element you already got in a jQuery obj and continue select deeper element related to that dom element 
            if($(floor).find('.u')[0].innerText === blocked){
                // console.log(floor)
                floor.remove()
                //if you wish to see the effect of blocking, uncomment this line and comment the line above
                //floor[i].style.visibility = 'hidden'
            }
        }
    })
    //console.log(document.readyState)
})();

//notification need wait for window ready, it loads after floor, as state shown as interactive in prev block
$(window).load(function(){
    var blocklist = ['user1','user2']
    //从通知栏移除屏蔽人的回复，杜绝污染
    console.log(document.readyState)
    //forEach only work for array object, commonNotification is list
    var removed = 0
    var blocked
    $('.commonNotificationsInfo').each(function(index,notification){
        // console.log(notification)
        for ( blocked of blocklist){
            if($(notification).find('a')[0].innerText === blocked){
                notification.parentNode.removeChild(notification)
                removed+=1
            }
        }
    })
    //修改消息栏小红点未读消息数目
    $('.tip-topBubble.tip-topBubble-1')[0].innerText -= removed
})

