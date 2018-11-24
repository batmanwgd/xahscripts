;; -*- coding: utf-8; lexical-binding: t; -*-

(setq xxoutputpath "~/web/xahlee_org/diklo/xx_xah_js_tutorial/")

(when (file-exists-p xxoutputpath) (delete-directory xxoutputpath "RECURSIVE" ) )

(xah-make-downloadable-copy
 "~/web/xahlee_info/"
 [
  "~/web/xahlee_info/js/"
  "~/web/xahlee_info/javascript_ecma-262_5.1_2011/"
  "~/web/xahlee_info/javascript_es6/"
  "~/web/xahlee_info/javascript_es2016/"
  "~/web/xahlee_info/jquery_doc/"
  "~/web/xahlee_info/node_api/"
  ]
 xxoutputpath)


