// ==UserScript==
// @name         Force https avoid not logged in
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @include      /^https?://(bangumi|bgm).tv.*$/
// @grant        none
// ==/UserScript==

(function() {
  'use strict';
/*if(window.location.protocol != 'https:') {
location.href =   location.href.replace("http://", "https://");
}*/
/*    if (location.protocol !== "https:") {
location.protocol = "https:";
}*/
    var current_host = window.location.host;
for (let a of document.querySelectorAll(`a.l`)){
  if(["bangumi.tv", "bgm.tv"].includes(a.host)){
    console.log(a)
      console.log("current_host:" + current_host)
      console.log("a.host:" + a.host)
    //change a.host to bangumi.tv to avoid repeat login
    if(a.host == "bgm.tv"){
      a.host = "bangumi.tv"
    }
    if(a.protocol!="https:"){
      a.protocol="https:"
    }
  }
}
  // Your code here...
})();