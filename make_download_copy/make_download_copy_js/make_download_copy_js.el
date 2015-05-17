;; -*- coding: utf-8 -*-

(setq xoutputpath "~/web/xahlee_org/diklo/xx_xah_js_tutorial/")

(when (file-exists-p xoutputpath) (delete-directory xoutputpath "RECURSIVE" ) )

(xah-make-downloadable-copy
 "~/web/xahlee_info/"
 [
  "~/web/xahlee_info/js/"
  "~/web/xahlee_info/javascript_ecma-262_5.1_2011/"
  "~/web/xahlee_info/jquery_doc/"
  "~/web/xahlee_info/node_api/"
  ]
 xoutputpath)



;; (xah-delete-files-by-regex xoutputpath "^backbone")
;; (delete-file (concat xoutputpath "js/blog.xml"))
