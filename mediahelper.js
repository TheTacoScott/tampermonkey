// ==UserScript==
// @name     Media Helper
// @include  http://localfoo:0000/b/*
// @require     http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js
// @grant    GM_setClipboard
// ==/UserScript==

var $previousclip = "";
setInterval(function() 
{
    
    if ($("div#virtclip").html() != $previousclip) {
        
        $previousclip = $("div#virtclip").html();
        console.log("Updating Clipboard to:" + $previousclip);
        GM_setClipboard($previousclip); 
        $("div#virtclip").html("");
    }
    
}, 200);
