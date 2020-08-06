// ==UserScript==
// @name         New Userscript
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        http://bangumi.tv/index/*
// @grant        none
// ==/UserScript==


//global var
if (window.itemList == undefined) {
    window.itemList = $('#browserItemList')[0].children
 }
 (function() {
     'use strict';
      for ( var i = 0 ; i < itemList.length ; i++){
          var arr = itemList[i].querySelector('.text').innerHTML.split(" ").slice(1)
          $('#browserItemList #comment_box .text')[i].innerHTML=''
          arr.forEach((item) => {
         var anchor = document.createElement('a');
         anchor.innerHTML = `${item} `
         anchor.addEventListener('click',function(){ filterTag(this)}, false)
         $('#browserItemList #comment_box .text')[i].appendChild(anchor)
     })
      }
     // Your code here...
 })();
 
 function filterTag(tag){
     console.log(`${tag.innerHTML}`);
     for( var i = 0 ; i < itemList.length ; i++){
         var tagAnchorList = $('#browserItemList #comment_box .text')[i].children
         var hide = true;
         for( var j = 0 ; j < tagAnchorList.length; j++){
             if(tagAnchorList[j].innerHTML.trim() == `${tag.innerHTML}`.trim()){
                 //console.log(tagAnchorList[j].innerHTML.trim())
                 //console.log( `${tag.innerHTML}`.trim())
                 console.log(tagAnchorList[j].parentNode)
                 hide = false
             }
         }
         if(hide){
             console.log(`item ${i} should be hide`)
             itemList[i].style.display = 'none'
         }
     }
  //   console.log(tag.parentNode)
 }
 
 
 