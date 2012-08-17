;; -*- coding: utf-8 -*-
;; 2010-08-25

;; delete <span class="kbd">...</span> tag.

(setq inputDir "~/ErgoEmacs_Source/website/" ) ; dir should end with a slash

(font-lock-mode 0)

(defun my-process-file (fpath)
  "process the file at fullpath fpath ..."
  (let ( mybuff changedQ)

    ;; open the file
    ;; search for the span.kbd tag
    ;; if found, delete it (and the closing tag), using sgml-delete-tag
    ;; repeat
    (setq mybuff (find-file fpath ) )
    (setq changedQ nil )

    (goto-char 0)
    (while
        (search-forward "<span class=\"kbd\">"  nil t)
      (when (yes-or-no-p "change? ")
        (backward-char 2)
        (sgml-delete-tag 1)
        (setq changedQ t )
        ))

    (if changedQ
        (progn (make-backup))                        ; leave it open
      (progn (kill-buffer mybuff))
      )
    ))

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*xah delete span.kbd tag*" )
  (with-output-to-temp-buffer outputBuffer
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )

(font-lock-mode 1)