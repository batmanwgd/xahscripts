;; -*- coding: utf-8; lexical-binding: t; -*-

(setq xoutputpath "/Users/xah/web/xahlee_org/diklo/x_xah_js_tutorial/")

(when (file-exists-p xoutputpath) (delete-directory xoutputpath "RECURSIVE" ) )

(xah-make-downloadable-copy
 "~/web/xahlee_info/"
 [
  "~/web/xahlee_info/js/"
  "~/web/xahlee_info/js_es2011/"
  "~/web/xahlee_info/js_es2015/"
  "~/web/xahlee_info/js_es2015_orig/"
  "~/web/xahlee_info/js_es2016/"
  "~/web/xahlee_info/js_es2018/"
  "~/web/xahlee_info/node_api/"

  ]
 xoutputpath)

