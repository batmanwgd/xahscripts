;; -*- coding: utf-8 -*-
;; 2010-08-25

;; change
;; <span class="code">...</span>
;; to
;; <code>...</code>

(setq inputDir "~/web/xahlee_org/" ) ; dir should end with a slash

(font-lock-mode 0)

(defun my-process-file (fpath)
  "process the file at fullpath fpath ..."
  (let ( mybuff changedQ p3 p4 p8 p9)

    ;; open the file
    ;; search for the tag
    ;; if found, move to the beginning of tag, mark positions of beginning and ending of < and >
    ;; use sgml-skip-tag-forward to move to the end matching tag </span>
    ;; mark positions of beginning and ending of < and >
    ;; replace them with <code> and </code> 
    ;; repeat
    (setq mybuff (find-file fpath ) )
    (setq changedQ nil )

    (goto-char 0)
    (while
        (search-forward "<span class=\"code\">"  nil t)
      (backward-char 1)
      (if (looking-at ">") 
          (setq p4 (1+ (point)) )
        (error "expecting <" )
        )

      ;; go to beginning of "<span class="code">"
      (sgml-skip-tag-backward 1)
      (if (looking-at "<") 
          (setq p3 (point) )
        (error "expecting <" )
        )
      (forward-char 2)

      ;; go to end of </span>
      (sgml-skip-tag-forward 1)
      (backward-char 1)
      (if (looking-at ">") 
          (setq p9 (1+ (point)) )
        (error "expecting >" )
        )

      ;; go to beginning of </span>
      (backward-char 6) 
      (if (looking-at "<") 
          (setq p8 (point) )
        (error "expecting <" )
        )
      
      (when (yes-or-no-p "change? ")
        (delete-region p8 p9  )
        (insert "</code>")
        (delete-region p4 p3 )
        (goto-char p3)
        (insert "<code>")
        (setq changedQ t )
        ))

    ;; if not changed, close it. Else, leave buffer open
    (if changedQ
        (progn (make-backup))                        ; leave it open
      (progn (kill-buffer mybuff))
      )
    ))

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*spam tag to code tag*" )
  (with-output-to-temp-buffer outputBuffer
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )

(font-lock-mode 1)