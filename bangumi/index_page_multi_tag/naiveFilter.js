// ==UserScript==
// @name         番组计划(bangumi)目录页多标签筛选
// @namespace    http://tampermonkey.net/
// @version      0.1.2.0
// @description  filter space separated tags in comment box on bangumi index page
// @author       You
// @include      /^https?://(bangumi|bgm).tv/index.*$/
// @icon         https://bangumi.tv/img/favicon.ico
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
   window.infotips = $('#browserItemList .info.tip')
   window.filterBar = $('#browserTools')[0]
   window.browserTypeSelector = $('#browserTools')[0].children[0]
   window.map = new Map()
   window.dict0 = new Map()
   window.dict1 = new Map()
}
//get rid of eslint syntax complaint
var itemList = window.itemList
var comments = window.comments
var infotips = window.infotips
var filterBar = window.filterBar
var browserTypeSelector = window.browserTypeSelector
var map = window.map
//store comment tag count
var dict0 = window.dict0
//store infotip tag count, we need 2 map bc each would generate a panel
var dict1 = window.dict1
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
     for ( let i = 0 ; i < comments.length ; i++){
         process(comments[i], true)
         process(infotips[i], false)
     }
    addSearchBar()
    addSideSummary("标签汇总",true)
    addSideSummary("时间/制作标签汇总",false)
})();
 
 
//use for both comment and infotip
function process(element, isComment){
    let tags
    let tagIds = []
    var dict
    if(isComment){
       tags = element.innerHTML.split(" ").slice(1);
       dict = dict0
    }else{
       //split infotip into different section, use innerText to avoid triming innerHTML
       let infotip = element.innerText.split(" / ");
       //extract all(global) number from the 1st section(date info) of infotip, map first 2 as YYYY and month, add default value to deal with unavailable date metadata
       const [year, month, day] = (infotip[0].match(/\d+/g) || [0,0]).map(Number)
       //concat date info and rest info into infoTag array, convert number to string in this step, so hashCode() won't yell
       //console.log(year+","+ month)
       if(year != 0 && month != 0){
           tags = infotip.slice(1).concat([year+"年",month+"月"])}
       else{
           tags = infotip.slice(1)}
       dict = dict1
    }
    element.innerHTML=''
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
        if(!dict.has(`${tag}`)){
            dict.set(`${tag}`,1)
        }else{
            dict.set(`${tag}`, dict.get(`${tag}`)+1)
        }
        element.appendChild(anchor)
        tagIds.push(tagId)
     })
     $(element).data('tagIds',tagIds)
}
 
function addSearchBar(){
   //create search bar
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
    label.innerHTML = '标签: '
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
}
 
function addSideSummary(groupName, isComment){
    //add tag whose occurence larger than threshold(2) to the right side to give a summary view
    let toBeInserted = $('#columnSubjectBrowserB')[0]
    let panel = document.createElement('div')
    panel.className = 'SidePanel png_bg'
    toBeInserted.append(panel)
    let panelTitle = document.createElement('h2')
    panelTitle.innerText = groupName
    panel.append(panelTitle)
    var tempDict = isComment ? dict0 : dict1 ;
    var dict = new Map([...tempDict].filter(([k,v]) => v > 2 && k !== "" ).sort((a, b) => (a[1] < b[1] && 1) || (a[1] === b[1] ? 0 : -1)))
    dict.forEach(function(value, key, map){
        //map here is map variable, thus the dict being iterated now, not the global var map
        //console.log(`${key}:${map.get(key)}`)
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
    }, panel)
}
 
function filterTag(tag, tagId){
    //if tag is one of the active filters, then ignore it
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
        let tagAnchorList = comments[i].children
        let hide = true;
        //comment
        for( let j = 0 ; j < tagAnchorList.length; j++){
            if(tagAnchorList[j].getAttribute('tagId') == tagId){
                hide = false
            }
        }
        //infotip
        tagAnchorList = infotips[i].children
        for( let j = 0; j < tagAnchorList.length; j++){
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
        if(itemQualified(activeFitlerIds, comments[i], infotips[i])){
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
 
function itemQualified(activeFitlerIds, comment, infotip){
    for(let i = 0 ; i < activeFitlerIds.length; i++){
        //if any of actived filter not present in either comment or infotip's tagIds, then item is not qualified
        if($(comment).data('tagIds').indexOf(activeFitlerIds[i]) == -1 && $(infotip).data('tagIds').indexOf(activeFitlerIds[i]) == -1){
            return false;
        }
    }
    return true;
}
