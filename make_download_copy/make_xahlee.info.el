;; -*- coding: utf-8 -*-

(when (file-exists-p "~/web/xahlee_org/diklo/xahlee_info/") 
  (delete-directory "~/web/xahlee_org/diklo/xahlee_info/" t ) )

(xah-make-downloadable-copy
  "~/web/xahlee_info/"
  [
   "~/web/xahlee_info/"
   ]
  "~/web/xahlee_org/diklo/xahlee_info/")



