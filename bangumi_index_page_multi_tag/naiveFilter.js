// ==UserScript==
// @name         bangumi index page tag filter
// @namespace    http://tampermonkey.net/
// @version      0.1.1.4
// @description  filter space separated tags in comment box on bangumi index page
// @author       You
// @include      /^https://(bangumi|bgm).tv/index.*$/
// @require      https://code.jquery.com/ui/1.12.1/jquery-ui.js
// @resource     jqueryuicss https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css
// @grant       unsafeWindow
// @grant       GM_addStyle
// @grant       GM_getResourceText

// ==/UserScript==
GM_addStyle(".tag_filter { display: inline-block; margin: 0 5px 5px 0; padding: 2px 5px; font-size: 12px; color: #dcdcdc; border-radius: 5px; line-height: 150%; background: #6e6e6e; cursor: pointer;}");
GM_addStyle(".tag_filter { font-family: 'SF Pro SC','SF Pro Display','PingFang SC','Lucida Grande','Helvetica Neue',Helvetica,Arial,Verdana,sans-serif,Hiragino Sans GB;}");
GM_addStyle(".tag { margin: 1px; cursor: pointer}");
GM_addStyle(".searchContainer { height: 25px; min-width: 100%}")
GM_addStyle(".searchLabel { height: 25px; min-width: 100%}")
GM_addStyle(".searchInput { position: relative; width: 80%; top: 0; left: 0; margin: 0; height: 25px !important; border-radius: 4px; background-color: white !important; outline: 0px solid white !important; border: 0p}")
GM_addStyle("#browserTools { height: 55px;}")
GM_addStyle(".grey {font-size: 10px; color: #999;}")
var newCSS = GM_getResourceText("jqueryuicss");
GM_addStyle (newCSS);

//global var
var $ = unsafeWindow.jQuery;
if (window.itemList == undefined) {
   window.itemList = $('#browserItemList')[0].children
   window.comments = $('#browserItemList #comment_box .text')
   window.filterBar = $('#browserTools')[0]
   window.browserTypeSelector = $('#browserTools')[0].children[0]
   window.map = new Map()
   window.dict0 = new Map()
   window.dict
}
//get rid of eslint syntax complaint
var itemList = window.itemList
var comments = window.comments
var filterBar = window.filterBar
var browserTypeSelector = window.browserTypeSelector
var map = window.map
var dict0 = window.dict0
var dict = window.dict
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
//      let map = new Map()
     for ( let i = 0 ; i < comments.length ; i++){
         let comment = comments[i]
         let tags = comments[i].innerHTML.split(" ").slice(1)
         let tagIds = []
         comment.innerHTML=''
         tags.forEach((tag) => {
            let anchor = document.createElement('a');
             //keep one trailing space, so when edit again in comment box, it will still be space separated
            anchor.innerHTML = `${tag} `
            anchor.className = 'tag'
            let tagId = tag.hashCode()
            anchor.setAttribute('tagId', tagId)
            //set onClick function of anchor is not viable, due to function is defined in userscript scope, which is outside target page scope. That's why when it evaluate the value of onClick attribute, it yells func not defined
            anchor.addEventListener('click',function(){ filterTag(this.innerHTML, tagId)}, false)
             //store map as string -> id
            if(!map.has(`${tag}`)){
                map.set(`${tag}`, tagId)
            }
            if(!dict0.has(`${tag}`)){
                dict0.set(`${tag}`,1)
            }else{
                dict0.set(`${tag}`, dict0.get(`${tag}`)+1)
            }
            comment.appendChild(anchor)
            tagIds.push(tagId)
         })
         //use jquery function, convert var to jquery object by wrap with $. btw, this doesn't actually create a data-tags attribute
         $(comment).data('tagIds',tagIds)
     }
    //create and add search bar
    let searchbar = document.createElement('div')
    searchbar.className = 'ui-widget searchContainer'
    filterBar.insertBefore(searchbar, browserTypeSelector)
    let activeFilter = document.createElement('div')
    activeFilter.style = 'display:flex'
    activeFilter.id = 'active_filter'
    searchbar.appendChild(activeFilter)
    let label = document.createElement('label')
    label.className = 'searchLabel'
    label.setAttribute('for','tags')
    label.innerHTML = 'Tags: '
    let input = document.createElement('input')
    input.id = 'tags'
    input.className = 'searchInput'
    searchbar.appendChild(label)
    searchbar.appendChild(input)
    //auto complete is a funciton in jquery-ui, need @require
    $('#tags').autocomplete ( {source: Array.from(map.keys()) ,
        minLength: 1});
//     $('#tags').attr('autocomplete','on');
    $("#tags").autocomplete({
        select: function( event, ui ) { filterTag(ui.item.value, map.get(ui.item.value)); $(this).val(''); return false;}
    })
    console.log(dict0)
    let toBeInserted = $('#columnSubjectBrowserB')[0]
    dict = new Map([...dict0].filter(([k,v]) => v > 2 && k !== "" ).sort((a, b) => (a[1] < b[1] && 1) || (a[1] === b[1] ? 0 : -1)))
    console.log(dict)
    dict.forEach(function(value, key, map){
     console.log(`${key}:${key.length}`)
     let tag = document.createElement('a')
     let count = document.createElement('small')
     tag.innerHTML = key
     tag.className = 'tag l'
     //Ugh, horrible naming
     tag.setAttribute('tagId', window.map.get(key))
     tag.addEventListener('click',function(){ filterTag(key, window.map.get(key))}, false)
     count.innerHTML = `(${value})`
     count.className = "grey"
     this.appendChild(tag)
     this.appendChild(count)
     // &nbsp;?
     this.append(' ')
    }, toBeInserted)

})();

function filterTag(tag, tagId){
    if(getActiveFilterIds().indexOf(tagId) != -1){
        return;
    }
    let filterButton = document.createElement('a')
    filterButton.innerHTML = tag
    filterButton.className = 'tag_filter'
    filterButton.id = tagId
    filterButton.addEventListener('click',function(){removeFilter(this)}, false)
    $('#active_filter')[0].appendChild(filterButton)
    for( let i = 0 ; i < itemList.length ; i++){
        let tagAnchorList = $('#browserItemList #comment_box .text')[i].children
        let hide = true;
        for( let j = 0 ; j < tagAnchorList.length; j++){
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

