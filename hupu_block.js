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
    var floor = $('.floor')
    for(var i=0;i<floor.length;i++){
        //console.log($users[i])
        //user[i] doesn't match $floor[i]
        if($(floor[i]).find('.u')[0].innerText === "someone"){
            console.log(floor[i])
            floor[i].style.visibility = 'hidden'
        }
    }
    console.log(document.readyState)
})();

//notification need wait for window ready, it loads slower than post and floor
$(window).load(function(){
    //从通知栏移除屏蔽人的回复，杜绝污染
    console.log(document.readyState)
    //forEach only work for array object, commonNotification is list
    var removed = 0
    $('.commonNotificationsInfo').each(function(index,notification){
        console.log(notification)
        if($(notification).find('a').innerText === "someone"){
            notification.parentNode.removeChild(notification)
            removed+=1
        }
    })
    //修改消息栏小红点未读消息数目
    $('.tip-topBubble.tip-topBubble-1')[0].innerText -= removed
})