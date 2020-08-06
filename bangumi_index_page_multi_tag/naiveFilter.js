// ==UserScript==
// @name         index page tag filter
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
    window.filterBar = $('#browserTools')[0]
    window.browserTypeSelector = $('#browserTools')[0].children[0]
 }
 //create hash from string
 Object.defineProperty(String.prototype, 'hashCode', {
   value: function() {
     var hash = 0, i, chr;
     for (i = 0; i < this.length; i++) {
       chr   = this.charCodeAt(i);
       hash  = ((hash << 5) - hash) + chr;
       hash |= 0; // Convert to 32bit integer
     }
     return hash;
   }
 });
 
 (function() {
     'use strict';
      for ( var i = 0 ; i < itemList.length ; i++){
          var arr = itemList[i].querySelector('.text').innerHTML.split(" ").slice(1)
          var tagArray = []
          var $comment =  $('#browserItemList #comment_box .text')[i]
          $comment.innerHTML=''
          arr.forEach((item) => {
             var anchor = document.createElement('a');
             anchor.innerHTML = `${item} `
             var tagId = item.hashCode()
             anchor.addEventListener('click',function(){ filterTag(this, tagId)}, false)
             $comment.appendChild(anchor)
             tagArray.push(tagId)
          })
          //this doesn't actually create a data-tags attribute
          $($comment).data('tags',tagArray)
          //console.log($($comment).data('tags'))
      }
     // Your code here...
 })();
 
 function filterTag(tag, tagId){
 //     console.log(`${tag.innerHTML}`);
     var filterButton = document.createElement('button')
     filterButton.innerHTML = `${tag.innerHTML}`
     filterButton.className = 'tag_filter'
     filterButton.id = tagId
     filterButton.addEventListener('click',function(){removeFilter(this)}, false)
     filterBar.insertBefore(filterButton, browserTypeSelector)
     for( var i = 0 ; i < itemList.length ; i++){
         var tagAnchorList = $('#browserItemList #comment_box .text')[i].children
         var hide = true;
         for( var j = 0 ; j < tagAnchorList.length; j++){
             if(tagAnchorList[j].innerHTML.trim().indexOf(`${tag.innerHTML}`.trim()) !== -1){
                 //console.log(tagAnchorList[j].innerHTML.trim())
                 //console.log( `${tag.innerHTML}`.trim())
                 //console.log(tagAnchorList[j].parentNode)
                 hide = false
             }
         }
         if(hide){
 //             console.log(`item ${i} should be hide`)
             itemList[i].style.display = 'none'
         }
     }
  //   console.log(tag.parentNode)
 }
 
 function removeFilter(tag){
     tag.parentNode.removeChild(tag);
     console.log(`tag ${tag.innerHTML}is removed`);
     //hide all items first
     $('.item.clearit').css( "display", "none" )
     console.log($('#browserItemList')[0].children)
     var activeFitlers = getActiveFilters()
     for(var i = 0; i < itemList.length; i++){
         var $comment = $('#browserItemList #comment_box .text')[i]
         var itemTags = $($comment).data('tags')
 //         console.log(itemTags)
 //         console.log(activeFitlers)
         if(itemQualified(activeFitlers, itemTags)){
             itemList[i].style.display = 'block'
         }
     }
 }
 
 function getActiveFilters(){
     return $('.tag_filter').map(function(){
         //return int instead of string
         return parseInt(this.id)
     })
     //return array instead of object
     .get()
 }
 
 function itemQualified(activeFilters, itemTags){
     for(var i = 0 ; i < activeFilters.length; i++){
         if(itemTags.indexOf(activeFilters[i]) == -1)
             return false;
     }
     return true;
 }
 
 
 
 
 