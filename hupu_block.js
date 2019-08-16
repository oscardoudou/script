// ==UserScript==
// @name         hupu block
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  block annoying peopel
// @author       oscardoudou
// @match        https://bbs.hupu.com/*
// @grant        none
// @require      https://code.jquery.com/jquery-3.4.1.min.js
// ==/UserScript==

(function() {
    'use strict';
    var users = $('.u')
    var $floor = $('.floor')
    var i
    for(i=0;i<$floor.length;i++){
        console.log($floor[i])
        //console.log(users[i])
        if(users[i].innerText === "someone"){
            console.log($floor[i])
            $floor[i].style.visibility = 'hidden'
        }
    }
})();