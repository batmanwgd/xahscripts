;; -*- coding: utf-8 -*-
;; 2010-08-25

;; delete curly quotes around span code tags. e.g.
;; “<span class="code">...</span>”
;; should be just
;; <span class="code">...</span>

(setq inputDir "~/web/xahlee_org/" ) ; dir should end with a slash

(font-lock-mode 0)

(defun my-process-file (fpath)
  "process the file at fullpath fpath ..."
  (let ( mybuff changedQ p3 p4)

    ;; open the file
    ;; search for the string “<span class="code">
    ;; if found, move to the beginning curly quote. delete it.
    ;; use sgml-skip-tag-forward to move to end of tag, delete the ending quote.
    ;; actually make sure it's there, else signify a error
    ;; repeat
    (setq mybuff (find-file fpath ) )
    (setq changedQ nil )

    (goto-char 0)
    (while
        (search-forward "“<span class=\"code\">"  nil t)
      (sgml-skip-tag-backward 1)
      (backward-char 1)
      (if (looking-at "“") 
          (setq p3 (point) )
        (error "expecting begin curly quote" )
        )
      ;; (search-backward "“" )          ; error if not found
      ;; (setq p3 (point) )
      (forward-char 2)
      (sgml-skip-tag-forward 1)
      (if (looking-at "”") 
          (setq p4 (point) )
        (error "expecting ending curly quote" )
        )
      
      (when (yes-or-no-p "change? ")
        (delete-region p4 (1+ p4) )
        (delete-region p3 (1+ p3) )
        (setq changedQ t )
        ))

    (if changedQ
        (progn (make-backup))                        ; leave it open
      (progn (kill-buffer mybuff))
      )
    ))

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*delete curly quote in span code tag*" )
  (with-output-to-temp-buffer outputBuffer
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )

(font-lock-mode 1)