;; -*- coding: utf-8; lexical-binding: t; -*-

(setq outputPath "/home/xah/web/xahlee_org/diklo/xx_xah_monkey_king/")


(when (file-exists-p outputPath)
  (delete-directory outputPath "RECURSIVE" ) )

 (xah-make-downloadable-copy
  "/home/xah/web/wordyenglish_com/"
  [
   "/home/xah/web/wordyenglish_com/monkey_king/"
   ]
  outputPath)

(shell-command (concat "python3 find_replace_ads.py3 " outputPath))

(shell-command (concat "python3 delete_temp_files.py3 " outputPath))

