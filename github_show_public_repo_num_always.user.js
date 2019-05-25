// ==UserScript==
// @name         github show public repo num when log in
// @namespace    https://github.com/oscardoudou/
// @version      0.1
// @description  after having your github logged in, you probably just want to see public repos count instead of total amount including too many trivial private repos. If u have obsession, this is the script.
// @author       oscardoudou
// @match        *://github.com/*
// @require      https://code.jquery.com/jquery-3.4.1.min.js
// @grant        none
// credit        https://stackoverflow.com/questions/10341135/example-of-using-github-api-from-javascript
// ==/UserScript==

(function() {
    'use strict'
    var user_login = $("meta[name='user-login']")[0].getAttribute('content')
    /*
    //$("title")[0].innerText
    var title = document.title
    var user_viewed
    //extract username if has user being viewd has alias name
    if(title.indexOf("(") != -1){
        user_viewed = title.substr(0,title.indexOf("(")-1)
    }
    //check if user being viewed is logged-in user
    if(user_viewed == user_login){
    */
        //below query works fine when using other's required script like ipcjs, the difference with current working one is the outer #js-pjax-container > div
        //document.querySelector("#js-pjax-container > div > div.col-9.float-left.pl-2 > div.UnderlineNav.user-profile-nav.js-sticky.top-0.is-stuck > nav > a.UnderlineNav-item.selected > span")
        var request = new XMLHttpRequest()
        //use callback
        request.onload = changeRepoToPubRepoCount;
        var apiUrl = 'https://api.github.com/users/'+user_login
        //3rd paramete defaults to true, dictates whether the response should be made asynchronously
        request.open('get',apiUrl)
        request.send()
    //}
})();

function changeRepoToPubRepoCount(){
    //use keyword this, otherwise using requset.responseText would get error when parsing
    var responseObj = JSON.parse(this.responseText)
    document.querySelector("div.col-9.float-left.pl-2 > div.UnderlineNav.user-profile-nav.js-sticky.top-0 > nav > a:nth-child(2) > span").innerText=responseObj.public_repos;
}