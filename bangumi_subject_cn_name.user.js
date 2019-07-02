// ==UserScript==
// @name         番组计划主页中文标题
// @namespace    https://github.com/oscardoudou/
// @version      0.1.2
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
    texts.forEach((item) => {
        item.innerHTML = item.getAttribute('data-subject-name-cn')
    })
    const liNodeList = document.getElementById('prgSubjectList').querySelectorAll(".clearit")
    liNodeList.forEach((item) => {
        //anime
        if(item.getAttribute('subject_type') === "2"){
            var title_ch = item.children[3].getAttribute('data-subject-name-cn')
            item.querySelectorAll("span")[1].innerHTML = title_ch
        }
        //book
        if(item.getAttribute('subject_type') === "1"){
            title_ch = item.children[2].getAttribute('data-subject-name-cn')
            item.querySelectorAll("span")[1].innerHTML = title_ch
        }
        //potential category
    })
})();
