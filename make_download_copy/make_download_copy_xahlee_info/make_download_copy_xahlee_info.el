;; -*- coding: utf-8 -*-

(setq xoutputpath "/home/xah/web/xahlee_org/diklo/yy_xahlee_info/")

(when (file-exists-p xoutputpath)
  (delete-directory xoutputpath "RECURSIVE" ) )

 (xah-make-downloadable-copy
  "/home/xah/web/xahlee_info/"
  [
   "/home/xah/web/xahlee_info/"
   ]
  xoutputpath)
