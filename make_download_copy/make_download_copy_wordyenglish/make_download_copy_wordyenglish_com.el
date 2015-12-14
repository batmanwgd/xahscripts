;; -*- coding: utf-8 -*-

(setq xoutputpath "/home/xah/web/xahlee_org/diklo/yy_wordyenglish/")

(when (file-exists-p xoutputpath)
  (delete-directory xoutputpath "RECURSIVE" ) )

 (xah-make-downloadable-copy
  "/home/xah/web/wordyenglish_com/"
  [
   "/home/xah/web/wordyenglish_com/"
   ]
  xoutputpath)
