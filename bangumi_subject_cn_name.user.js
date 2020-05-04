// ==UserScript==
// @name         番组计划主页中文标题
// @namespace    https://github.com/oscardoudou/
// @version      0.1.2.1
// @description  Bangumi番组计划中文标题
// @author       oscardoudou
// @include      *://bgm.tv/
// @include      *://bangumi.tv/
// @grant        none
// credit        ipcjs
// ==/UserScript==


(function() {
    'use strict'
    const texts = document.querySelectorAll('.infoWrapper_tv .headerInner .l.textTip')
    const liNodeList = document.getElementById('prgSubjectList').querySelectorAll(".clearit")
    liNodeList.forEach((item,index) => {
        //anime
        if(item.getAttribute('subject_type') === "2"){
            var title_ch = item.children[3].getAttribute('data-subject-name-cn')
            //only replace original title when cn title availablt
           if(title_ch != ""){
            item.querySelectorAll("span")[1].innerHTML = title_ch
            texts[index].innerHTML = texts[index].getAttribute('data-subject-name-cn')
           }
        }
        //book
        if(item.getAttribute('subject_type') === "1"){
            //todo book w/o cn title check
            //detailview title replace
            title_ch = item.children[2].getAttribute('data-subject-name-cn')
            item.querySelectorAll("span")[1].innerHTML = title_ch
        }
        //potential category
    })
})();