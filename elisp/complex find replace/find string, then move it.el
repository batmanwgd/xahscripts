; -*- coding: utf-8 -*-

; give a dir
; for all files in the dir
; find a string, and move it to particular location in the file.

(setq inputDir "c:/Users/xah/web/xahlee_org/MathGraphicsGallery_dir/dense/m/" ) ; dir should end with a slash

; functions

; open a file, process it
(defun my-process-file (fpath)
  "process the file at fullpath fpath ..."
  (let (mybuffer p1 p2 meat )

    (when (and (not (string-match "/xx" fpath))
               (not (string-match "/more\\.html" fpath))
;               (string-match "A-Sample-Function-Description.html" fpath)
               )
 
      (setq mybuffer (find-file fpath))
      (goto-char 1) ;; in case buffer already open

      (when (search-forward "<div class=\"nav\">" nil t)
        (search-backward "\n")
        (forward-char)
        (setq p1 (point))
        (search-forward "\n")
        (backward-char)
        (setq p2 (point))

        (setq meat (buffer-substring-no-properties p1 p2))

        ;; delete the text
        (delete-region p1 p2)

        ;; insert at new location
        (goto-char 1)
        (search-forward "<div class=\"img\">")
        (search-backward "\n")

        (insert "\n" meat)
        )

      (save-buffer mybuffer)
      (kill-buffer mybuffer)
      )
))


; main

(desktop-save-mode 0)

(require 'find-lisp)
(mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))

(message "Done deal!")