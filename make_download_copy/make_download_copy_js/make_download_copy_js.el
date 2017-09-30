;; -*- coding: utf-8; lexical-binding: t; -*-

(setq xxoutputpath "~/web/xahlee_org/diklo/xx_xah_js_tutorial/")

(when (file-exists-p xxoutputpath) (delete-directory xxoutputpath "RECURSIVE" ) )

(xah-make-downloadable-copy
 "/home/xah/web/xahlee_info/"
 [
  "/home/xah/web/xahlee_info/js/"
  "/home/xah/web/xahlee_info/javascript_ecma-262_5.1_2011/"
  "/home/xah/web/xahlee_info/javascript_es6/"
  "/home/xah/web/xahlee_info/javascript_es2016/"
  "/home/xah/web/xahlee_info/html5_whatwg/"
  "/home/xah/web/xahlee_info/dom-whatwg/"
  "/home/xah/web/xahlee_info/jquery_doc/"
  "/home/xah/web/xahlee_info/node_api/"
  ]
 xxoutputpath)



(xah-delete-files-by-regex xxoutputpath "^backbone")
