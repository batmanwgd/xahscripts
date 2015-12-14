;; -*- coding: utf-8 -*-

(setq xoutputpath "/home/xah/web/xahlee_org/diklo/yy_xaharts/")

(when (file-exists-p xoutputpath)
  (delete-directory xoutputpath "RECURSIVE" ) )

 (xah-make-downloadable-copy
  "/home/xah/web/xaharts_org/"
  [
  "/home/xah/web/xaharts_org/"
   ]
  xoutputpath)
