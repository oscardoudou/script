// ==UserScript==
// @name         bangumi index page tag filter
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  filter space separated tags in comment box on bangumi index page
// @author       You
// @match        http://bangumi.tv/index/*
// @require      https://code.jquery.com/ui/1.12.1/jquery-ui.js
// @resource     customcss https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css
// @grant       unsafeWindow
// @grant       GM_addStyle
// @grant       GM_getResourceText

// ==/UserScript==
// as long as you add/grant GM_addStyle, you shouldn't need self defined one below
// function GM_addStyle(css) {
//   const style = document.getElementById("GM_addStyleBy8626") || (function() {
//     const style = document.createElement('style');
//     style.type = 'text/css';
//     style.id = "GM_addStyleBy8626";
//     document.head.appendChild(style);
//     return style;
//   })();
//   const sheet = style.sheet;
//   sheet.insertRule(css, (sheet.rules || sheet.cssRules || []).length);
// }


GM_addStyle(".tag_filter { border: 1px solid #77bc1f;}");
GM_addStyle(".tag_filter { display: inline-block;}");
GM_addStyle(".tag_filter { margin: 3px;}");
GM_addStyle(".tag_filter { padding: 6px;}");
GM_addStyle(".tag_filter { font-size: 16px;}");
GM_addStyle(".tag_filter { color: black;}");
GM_addStyle(".tag { margin: 2px;}");
var newCSS = GM_getResourceText ("customCSS");
GM_addStyle (newCSS);

//global var
var $ = unsafeWindow.jQuery;
if (window.itemList == undefined) {
   window.itemList = $('#browserItemList')[0].children
   window.comments = $('#browserItemList #comment_box .text')
   window.filterBar = $('#browserTools')[0]
   window.browserTypeSelector = $('#browserTools')[0].children[0]
}
//get rid of eslint syntax complaint
var itemList = window.itemList
var comments = window.comments
var filterBar = window.filterBar
var browserTypeSelector = window.browserTypeSelector
//create hash from string
Object.defineProperty(String.prototype, 'hashCode', {
  value: function() {
    var hash = 0, i, chr;
    for (i = 0; i < this.length; i++) {
      chr = this.charCodeAt(i);
      hash = ((hash << 5) - hash) + chr;
      hash |= 0; // Convert to 32bit integer
    }
    return hash;
  }
});

(function() {
    'use strict';
     let map = new Map()
     for ( let i = 0 ; i < comments.length ; i++){
         let comment = comments[i]
         let tags = comments[i].innerHTML.split(" ").slice(1)
         let tagIds = []
         comment.innerHTML=''
         tags.forEach((tag) => {
            let anchor = document.createElement('a');
            anchor.innerHTML = `${tag}`
            anchor.className = 'tag'
            let tagId = tag.hashCode()
//             $(anchor).data('tagId', tagId)
            anchor.setAttribute('tagId', tagId)
            //set onClick function of anchor is not viable, due to function is defined in userscript scope, wihich is outside target page scope. That's why when it evaluate the value of onClick attribute, it yells func not defined
            anchor.addEventListener('click',function(){ filterTag(this, tagId)}, false)
            if(!map.has(tagId)){
                map.set(tagId, `${tag}`)
            }
            comment.appendChild(anchor)
            tagIds.push(tagId)
         })
         //use jquery function, convert var to jquery object by wrap with $. btw, this doesn't actually create a data-tags attribute
         $(comment).data('tagIds',tagIds)
     }
    //crate and add search bar
    let searchbar = document.createElement('div')
    searchbar.className = 'ui-widget'
    searchbar.id = 'tags'
    let label = document.createElement('label')
    label.for = 'tags'
    label.innerHTML = 'Tags: '
    let input = document.createElement('input')
    input.id = 'tags'
    searchbar.appendChild(label)
    searchbar.appendChild(input)
    filterBar.insertBefore(searchbar, browserTypeSelector)
//     $(searchbar).autocomplete({
//       source: map.values()
//     });
    console.log(Array.from(map.values()))
    //auto complete is a funciton in jquery-ui, need @require
    $("#tags").autocomplete ( {source: ["scat","anal"] });
//     searchbar.addEventListener('focus', function(){
//         this.autocomplete = "on";
//     });
    //     $("#tags").removeAttribute("autocomplete");

})();

function filterTag(tag, tagId){
    if(getActiveFilterIds().indexOf(tagId) != -1){
        return;
    }
    let filterButton = document.createElement('button')
    filterButton.innerHTML = `${tag.innerHTML}`
    filterButton.className = 'tag_filter'
    filterButton.id = tagId
    filterButton.addEventListener('click',function(){removeFilter(this)}, false)
    filterBar.insertBefore(filterButton, browserTypeSelector)
    for( let i = 0 ; i < itemList.length ; i++){
        let tagAnchorList = $('#browserItemList #comment_box .text')[i].children
        let hide = true;
        for( let j = 0 ; j < tagAnchorList.length; j++){
//             if(tagAnchorList[j].innerHTML.indexOf(`${tag.innerHTML}`) !== -1){
//             console.log($(tagAnchorList[j]).data('tagId'))
//             if($(tagAnchorList[j]).data('tagId') == tagId){
            if(tagAnchorList[j].getAttribute('tagId') == tagId){
                hide = false
            }
        }
        if(hide){
            itemList[i].style.display = 'none'
        }
    }
}

function removeFilter(tag){
    tag.parentNode.removeChild(tag);
    //hide all items first
    $('.item.clearit').css( "display", "none" )
    let activeFitlerIds = getActiveFilterIds()
    for(let i = 0; i < itemList.length; i++){
        let comment = comments[i]
        let tagIds = $(comment).data('tagIds')
        if(itemQualified(activeFitlerIds, tagIds)){
            itemList[i].style.display = 'block'
        }
    }
}

function getActiveFilterIds(){
    return $('.tag_filter').map(function(){
        //return int instead of string
        return parseInt(this.id)
    })
    //return array instead of jquery object
    .get()
}

function itemQualified(activeFitlerIds, tagIds){
    for(let i = 0 ; i < activeFitlerIds.length; i++){
        if(tagIds.indexOf(activeFitlerIds[i]) == -1){
            return false;
        }
    }
    return true;
}

