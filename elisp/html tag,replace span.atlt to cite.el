;; -*- coding: utf-8 -*-
;; 2011-07-18, 2011-08-13
;; replace <span class="atlt">…</span> to <cite>…</cite>
;;
;; do this for all files in a dir.

(setq inputDir "~/web/xahlee_org/emacs/" ) ; dir should end with a slash

(setq changedItems '())

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (myBuff myword)
    (setq myBuff (find-file fPath))

    (widen) (goto-char 1) ;; in case buffer already open

    (while (search-forward-regexp "<span class=\"bktl\">\\([^<]+?\\)</span>" nil t)
      (setq myword (match-string 1))
      (when
          ;; a little double check in case of possibe mismatched tag
          (and
             (< (length myword) 200)
             (not (string-match "<\\|>" myword ))
             )
        (replace-match (concat "<cite class=\"book\">" myword "</cite>" )  t) 
        (setq changedItems (cons (vector (substring-no-properties myword) fPath) changedItems ) )
        ) )

    ;; close buffer if there's no change. Else leave it open.
    (when (not (buffer-modified-p myBuff)) (kill-buffer myBuff) )
    ) )

(require 'find-lisp)

(setq make-backup-files t)
(setq case-fold-search nil)
(setq case-replace nil)

(let (outputBuffer)
  (setq outputBuffer "*xah span.atlt to cite replace output*" )
  (with-output-to-temp-buffer outputBuffer
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    ;; (print changedItems)
    ;; (mapc (lambda (xx) (prin1 xx) (terpri)) '("some this" "an b"))
    (mapc (lambda (xx) (princ (elt xx 0)) (princ "———			") (princ (elt xx 1)) (terpri) ) changedItems)

    (terpri)
    (princ "Done deal!")
    )
  )
