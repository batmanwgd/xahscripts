;; -*- coding: utf-8 -*-
;; 2012-03-31
;; revert a list of files. If a file path is xyz, then revert from the file xyz~ (or other suffix)

(setq myFileList
[
"c:/Users/h3/web/xahlee_info/js/css_layout_tableless.html"
"c:/Users/h3/web/xahlee_info/js/ex/Google_webfont_sample.html"
"c:/Users/h3/web/xahlee_info/js/ex/WebKit_pre_rendering_bug.html"

]
 )

(mapc 
 (lambda (ξx)
   (let (
         (tildePath (concat ξx "~bk~"))
         )
     (copy-file tildePath ξx "already exist ok")
     
     )
   )

 myFileList)