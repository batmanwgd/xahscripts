// 2013-07-14

// find the base path of a script
var settings91976 = {};
settings91976.basePath = null;

if (!settings91976.basePath) {
  (function (name) {
    var scripts = document.getElementsByTagName('script');
    for (var i = scripts.length - 1; i >= 0; --i) {
      var src = scripts[i].src;
      var l = src.length;
      var length = name.length;
      if (src.substr(l - length) == name) {
        // set a global propery here
        settings91976.basePath = src.substr(0, l - length);

      }
    }
  })("emacs_tooltip-chose.js");
}

console.log( "basepath is:" + settings91976.basePath);

function getFullPathFromRelativePath (path84721) {
// returns the full path of the relative path path84721, relative to the js file this function is called

}

var url84026 = window.location.href;

if (url84026.substring(0,4) === "file"  ) {

var e31618 = document.createElement("script");
e31618.type = "text/javascript";
e31618.src = settings91976.basePath + "emacs_tooltip-local.js";
document.body.appendChild(e31618);

// "file:///home/xah/web/ergoemacs_org/emacs/emacs_tooltip-local.js"

}


// console.log( "document.currentScript.src isssssss" + document.currentScript.src); // not supported in Google Chrome as of 2013-07-14
