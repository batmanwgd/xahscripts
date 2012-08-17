; -*- coding: utf-8 -*-
; 2010-03-11

;; if a file has 2 nav bar, delete the second one.
; • this script makes sure that the 2 nav bar's string are identical

(setq inputDir "c:/Users/xah/web/xahlee_org/js/" ) ; dir should end with a slash

; open a file, process it
(defun my-process-file (fpath)
  "Process the file at path FPATH ..."
  (let (mybuffer p1 p2 meat1 meat2 (ii 0))

    (when (and (not (string-match "/xx" fpath))
               (not (string-match "/more\\.html" fpath))
               )

      (set-buffer (get-buffer-create " myTemp"))
      (insert-file-contents fpath nil nil nil t)
      
      ;; count nav bar occurance
      (goto-char 1)
      (while (search-forward "<div class=\"nav\">" nil t)
        (setq ii (1+ ii))
        )

      ;; if 2 nav bar, make sure they are identical, if so, delete the second one
      (when (= ii 2)
        (goto-char 1)
        (search-forward "<div class=\"nav\">" nil t)
        (search-backward "<div")
        (setq p1 (point))
        (search-forward "\n")
        (backward-char)
        (setq p2 (point))
        (setq meat1 (buffer-substring-no-properties p1 p2))

        (search-forward "<div class=\"nav\">" nil t)
        (search-backward "<div")
        (setq p1 (point))
        (search-forward "\n")
        (backward-char)
        (setq p2 (point))
        (setq meat2 (buffer-substring-no-properties p1 p2))

        (when (not (equal meat1 meat2 ))
            (message "problem: %d %s" ii fpath)
          )

        (delete-region p1 p2)

        (copy-file fpath (concat fpath "~e~") t) ;make backup
        (write-file fpath)
        )

      (kill-buffer)
      )

))

(require 'find-lisp)
(mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))

(message "Done deal!")

(switch-to-buffer "*Messages*")