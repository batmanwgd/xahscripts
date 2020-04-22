;; -*- coding: utf-8; lexical-binding: t; -*-

(setq outputPath "~/web/xahlee_org/diklo/z_xah_emacs_tutorial/")

;; (setq outputPath "/Users/xah/web/xahlee_info/xdl07106/xah_emacs_tutorial")

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

(shell-command (concat "python3 find_replace_ads.py3 " outputPath))

(shell-command (concat "python3 delete_temp_files.py3 " outputPath))
