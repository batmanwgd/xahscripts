;; -*- coding: utf-8 -*-
;; 2010-03-27
;; report how many occurances of a string, of a given dir

(setq inputDir "~/web/xahlee_info/" ) ; must end with a slash
(setq inputDir "~/web/ergoemacs_org/" ) ; must end with a slash
(setq inputDir "~/web/xahlee_org/emacs/" ) ; must end with a slash
(setq inputDir "~/web/xahlee_org/music/" ) ; must end with a slash
(setq inputDir "~/web/xahlee_org/math/" ) ; must end with a slash
(setq inputDir "~/web/xahlee_org/p/" ) ; must end with a slash
(setq inputDir "~/web/xahlee_org/kbd/" ) ; must end with a slash
(setq inputDir "~/web/xahlee_org/math/" ) ; must end with a slash
(setq inputDir "~/web/xahlee_org/comp/" ) ; must end with a slash
(setq inputDir "~/web/xahlee_org/Periodic_dosage_dir/" ) ; must end with a slash
(setq inputDir "~/web/xahlee_org/" ) ; must end with a slash

(setq searchStr1 "<img src=\"\\([^\"]+?\\)\" alt=\"\\([^\"]+?\\)\" width=\"\\([0-9]+\\)\" height=\"\\([0-9]+\\)\">" )
(setq searchStr1 "~[0-9]\\{1,3\\}[^[:digit:]]" )
(setq searchStr1 "~$[0-9]+)" )
(setq searchStr1 "(c\\.? *\\([0-9]+\\)-" )


(setq caseSensitiveFind t)
(setq printContext t)

;; add a ending slash if not there
(when (not (string= "/" (substring inputDir -1) )) (setq inputDir (concat inputDir "/") ) )

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let ((ξcount 0)
(fPathPrint (replace-regexp-in-string "c:/Users/h3/" "~/" fPath t t))
(ξpos1 1) ; beginning of line
(ξpos2 1)
(ξpos-prev-end 1)
)

    (when (not (string-match "/xx" fPath))
      (with-temp-buffer
        (insert-file-contents fPath)
        (setq case-fold-search caseSensitiveFind)
        (while (search-forward-regexp searchStr1 nil t)
          (setq ξpos-prev-end ξpos2)
          (setq ξpos1 (- (match-beginning 0) 30))
          (setq ξpos2 (+ (match-end 0) 30))
          (setq ξpos1 (line-beginning-position))
          (setq ξpos2 (line-end-position))
          (if printContext
              (when (> (point) ξpos-prev-end)
                  (princ (format "「%s」\n" (buffer-substring-no-properties ξpos1 ξpos2 ))))
            (princ (format "「%s」\n" (match-string 0)))
            )
          (setq ξcount (1+ ξcount))
          )

        ;; report if the occurance is not n times
        (if (> ξcount 0)
            (princ (format "• %d %s\n" ξcount fPathPrint))
          )
        )
      )

    ))

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*xah occur output*" )
  (with-output-to-temp-buffer outputBuffer
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )

  (switch-to-buffer outputBuffer)
  (highlight-phrase searchStr1 (quote hi-yellow))
  (highlight-lines-matching-regexp "• " (quote hi-pink))

  )
