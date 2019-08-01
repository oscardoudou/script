// ==UserScript==
// @name         github show public repo num when log in
// @namespace    https://github.com/oscardoudou/
// @version      0.1.1
// @description  after having your github logged in, you probably just want to see public repos count instead of total amount including too many trivial private repos. If u have obsession with ur repo count, this is the script for u.
// @author       oscardoudou
// @match        *://github.com/*
// @exclude      *://github.com/*/*
// @require      https://code.jquery.com/jquery-3.4.1.min.js
// @grant        none
// credit        https://stackoverflow.com/questions/10341135/example-of-using-github-api-from-javascript
// ==/UserScript==

(function() {
    'use strict'
    var user_login = $("meta[name='user-login']")[0].getAttribute('content')
    var user_viewed = document.getElementsByClassName('vcard-names')[0].lastElementChild.innerText
    //check if user being viewed is logged-in user
    if(user_viewed === user_login){
        var request = new XMLHttpRequest()
        //use callback
        request.onload = changeRepoToPubRepoCount;
        var apiUrl = 'https://api.github.com/users/'+user_login
        //3rd paramete defaults to true, dictates whether the response should be made asynchronously
        request.open('get',apiUrl)
        request.send()
    }
})();

function changeRepoToPubRepoCount(){
    var responseObj = JSON.parse(this.responseText)
    document.querySelector("div.UnderlineNav.user-profile-nav.js-sticky.top-0 > nav > a:nth-child(2) > span").innerText=responseObj.public_repos;
}
