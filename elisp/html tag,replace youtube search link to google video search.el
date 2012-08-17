; -*- coding: utf-8 -*-
;; 2010-06-06

; give a dir
; for all html files in the dir
; replace youtube search links to google video search links.

;; e.g. from

;; <a class="utb" href="http://youtube.com/results?search_query=White+Rabbit%2C+Jefferson+Airplane&amp;search=Search">White Rabbit, Jefferson Airplane</a>

;; to
; <a class="gvidsr" href="http://www.google.com/search?tbs=vid%3A1&q=White+Rabbit%2C+Jefferson+Airplane">White Rabbit, Jefferson Airplane</a>

;; todo: this script leaves all files open. Need to close files that have not been changed.

(setq inputDir "~/web/xahlee_org/Periodic_dosage_dir/sanga_pemci/" ) ; dir should end with a slash

; functions

; open a file, process it
(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (myBuffer tagBegin tagEnd lnkTxtBegin lnkTxtEnd lnkText url )

    (when t
 
      (setq myBuffer (find-file fPath))
      (goto-char 1) ;; in case buffer already open

      (while (search-forward "<a class=\"utb\"" nil t)
        (search-backward "<")
        (setq tagBegin (point))
        (search-forward ">")
        (setq lnkTxtBegin (point))
        (search-forward "<")
        (backward-char)
        (setq lnkTxtEnd (point))
        (setq tagEnd (+ lnkTxtEnd 4))

        (setq lnkText (buffer-substring-no-properties lnkTxtBegin lnkTxtEnd))
        (setq url (replace-regexp-in-string "&" "&amp;" (video-search-string lnkText) ) )

        ;; delete the text
        (delete-region tagBegin tagEnd)

        (insert  (concat "<a class=\"gvidsr\" href=\"" url "\">" lnkText "</a>"))
        )
      )
))


; main

(desktop-save-mode 0)

(require 'find-lisp)
(mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))

(message "Done deal!")