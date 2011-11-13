// ==UserScript==
// @name          Google Reader share
// @namespace     greadershare
// @description   Brings back the Share button to Google Reader. 
// @include       http://www.google.com/reader/view/*
// @include       https://www.google.com/reader/view/*
// @version       0.2
// ==/UserScript==

var d = document;
var ss = d.createElement('script');
ss.src = 'http://lipsumarium.com/greader/greader-share.js?nc='+Math.random();
d.body.appendChild(ss);

