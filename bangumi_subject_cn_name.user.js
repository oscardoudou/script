// ==UserScript==
// @name         番组计划主页中文标题
// @namespace    https://github.com/oscardoudou/
// @version      0.1
// @description  Bangumi番组计划中文标题
// @author       oscardoudou
// @include      *://bgm.tv/
// @include      *://bangumi.tv/
// @require      https://greasyfork.org/scripts/373283-ipcjs-lib-js/code/ipcjslibjs.js?version=637066
// @require-origin https://raw.githubusercontent.com/ipcjs/bilibili-helper/user.js/ipcjs.lib.js
// @grant        none
// credit        ipcjs
// ==/UserScript==


ipcjs.installInto(({ log, _, html }) => {
    const texts = document.querySelectorAll('.infoWrapper_tv .headerInner .l.textTip')
    texts.forEach((item) => {
        item.innerHTML = item.getAttribute('data-subject-name-cn')
    })
    //getElementById would return one object, while querlySelectorAll would return list, so u have to append index to access one
    //we use querySelectorAll after getElementById, only because what querySelectorAll return  could do forEach, which is werid
    const liNodeList = document.getElementById('prgSubjectList').querySelectorAll(".clearit")
    console.log(liNodeList)
    liNodeList.forEach((item) => {
        //anime
        if(item.getAttribute('subject_type') === "2"){
            var title_ch = item.children[3].getAttribute('data-subject-name-cn')
            console.log(title_ch)
            item.querySelectorAll("span")[1].innerHTML = title_ch
        }
        //book
        if(item.getAttribute('subject_type') === "1"){
            title_ch = item.children[2].getAttribute('data-subject-name-cn')
            console.log(title_ch)
            item.querySelectorAll("span")[1].innerHTML = title_ch
        }
        //potential category
    })
})


