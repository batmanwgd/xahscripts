;; -*- coding: utf-8 -*-
;; 2011-07-18
;; replace <span class="w">…</span> to <b>…</b>
;;
;; do this for all files in a dir.

(setq inputDir "~/web/xahlee_org/PageTwo_dir/Vocabulary_dir/" ) ; dir should end with a slash

(setq changedItems '())

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (myBuff myword)
    (setq myBuff (find-file fPath))

    (widen) (goto-char 1) ;; in case buffer already open

    (while (search-forward-regexp "<span class=\"w\">\\([^<]+?\\)</span>" nil t)
      (setq myword (match-string 1))
      (when (< (length myword) 15) ; a little double check in case of possibe mismatched tag
        (replace-match (concat "<b>" myword "</b>" )  t) 
        (setq changedItems (cons (substring-no-properties myword) changedItems ) )
        ) )

    ;; close buffer if there's no change. Else leave it open.
    (when (not (buffer-modified-p myBuff)) (kill-buffer myBuff) )
    ) )

(require 'find-lisp)

(setq make-backup-files t)
(setq case-fold-search nil)
(setq case-replace nil)

(let (outputBuffer)
  (setq outputBuffer "*xah span.w to b replace output*" )
  (with-output-to-temp-buffer outputBuffer
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (print changedItems)
    (princ "Done deal!")
    )
  )
