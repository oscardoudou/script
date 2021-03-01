// ==UserScript==
// @name         New Userscript
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        http://bangumi.tv/index/*
// @grant        none
// ==/UserScript==

//1. can inject function from GreasyMonkey as dom onClick function -> workaround addEventListener
//2. onload callback can't pass parameter in parenthesis -> workaround set parameter in request.extraInfo and this.extraInfo 
//3. GET https://api.bgm.tv/collection/XXX?access_token=api_token net::ERR_FAILED
//   Access to XMLHttpRequest at 'https://api.bgm.tv/collection/XXX?access_token=api_token' from origin 'http://bangumi.tv' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource.

(function() {
    'use strict';
        //get your api token
        var api_token = ''
        var itemList = $('#browserItemList')[0].children
        for(var i = 0; i < itemList.length; i++){
            var item = itemList[i]
            var subjectId = item.id.substring(5);
            console.log(subjectId)
            var apiUrl = 'https://api.bgm.tv/collection/'+subjectId+'?access_token='+api_token
            console.log(apiUrl)
            var request = new XMLHttpRequest()
            request.extraInfo = i
            request.onload = loadSubjectTagCreatedByUser
            request.open('get',apiUrl)
            request.send()
        }
    // Your code here...
})();

function loadSubjectTagCreatedByUser(){
    console.log(this.responseText)
    var responseObj = JSON.parse(this.responseText)
    //tag will be used to replaced
    var tagArray = responseObj.tag
    console.log(tagArray)
    var index=this.extraInfo
    $('#browserItemList #comment_box .text')[index].innerHTML=''
    tagArray.forEach((item) => {
        var anchor = document.createElement('a');
        anchor.innerHTML = `${item} `
        anchor.addEventListener('click',function(){ console.log(this.innerHTML)}, false)
        $('#browserItemList #comment_box .text')[index].appendChild(anchor)
    })
}

