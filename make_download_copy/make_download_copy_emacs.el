;; -*- coding: utf-8 -*-

(setq outputPath "~/web/xahlee_org/diklo/xx_xah_emacs_tutorial/")

(when (file-exists-p outputPath)
  (delete-directory outputPath "RECURSIVE" ) )

 (xah-make-downloadable-copy
  "~/web/ergoemacs_org/"
  [
   "~/web/ergoemacs_org/"
  ;; "~/web/ergoemacs_org/emacs/"
;   "~/web/ergoemacs_org/emacs_manual/"
;   "~/web/ergoemacs_org/misc/"
;   "~/web/ergoemacs_org/i/"
   ]
  outputPath)

