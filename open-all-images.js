// ==UserScript==
// @name        General Webpage Helpers
// @namespace   tacoscott.com
// @include     http*
// @exclude     192*
// @version     4
// @require     http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js
// @grant       GM_addStyle
// ==/UserScript==

function open_images_in_new_tab_v2() 
{ 
   console.log("open_images_in_new_tab_v2");
   var images = [];
   $('a[href]').filter(function() {
        if (/\.(tga|bmp|jpeg|jpg|gif|png)$/i.test($(this).attr('href')))
        {
            if (/.*whatever.*/i.test(window.location))
            {
                newurl = $(this).find("img").first().attr('src');
            }
            else
            {
                newurl = $(this).prop('href');
            }
            imghtml = "<img class='reg' src='"+newurl+"'>"; 
            if($.inArray(imghtml, images) == -1) { images.push(imghtml); }  
        }
   });
   images.push("<img class='zoom lowz' src=''>");
   
    newhead = "";
    newhead += '<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>' + "\n";
    newhead += '<style>' + "\n";
    newhead += 'body {background-color: black; padding: 0px;}' + "\n";
    newhead += '.reg { width: 100%; margin: 0px; margin-bottom: 2px; display:block;}' + "\n";
    newhead += '.zoom {position: absolute; top:1px; left: 1px; }' + "\n";
    newhead += '.lowz { z-index: -5000; visibility: hidden; }' + "\n";
    newhead += '.highz { z-index: 5000; visibility: visable;}' + "\n";
    newhead += '#main {column-fill: balance;-webkit-column-count:5;-webkit-column-gap:2px;position: absolute; top:0; left:0;}' + "\n";
    newhead += '#lightbox {  position:fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,.9); z-index: 1000;}';
    newhead += '.hider {  display: none; }';
    newhead += '</style>' + "\n";
    
   newbody = "<div id='lightbox' class='hider'></div>";
   newbody += '<center id="main">' + "\n";
   newbody+=images.join('');
   newbody += '</center>' + "\n";
    
   $('html').removeClass();
   $('body').removeClass();
   $('head').html(newhead);
   $('body').html(newbody);
   
   $(window).scrollTop(0); 
    
   $("img").click(function() {
             
       if ($(this).hasClass("zoom"))
       {
          $(this).attr("src","").toggleClass("lowz highz");
          $("#lightbox").toggleClass("hider");
          $(window).scrollTop($prevpos);
       }
       else
       {
          $(".zoom").attr("src",$(this).attr("src")).toggleClass("lowz highz");
          $("#lightbox").toggleClass("hider");
          $prevpos = $(window).scrollTop();
          $(window).scrollTop(0);
       } 
       
   });   
   
}

$(document).keypress(function(e) {
    console.log(e.which);
    if(e.ctrlKey && e.shiftKey && e.which === 26) { open_images_in_new_tab_v2();} // 90 = z
});
        





