;; -*- coding: utf-8 -*-
;; 2011-03-21
;; report the position (line number) of a occurances of string, of a given dir

(setq inputDir "~/web/xahlee_org/p/" )

;; add a ending slash if not there
(when (not (string= "/" (substring inputDir -1) )) (setq inputDir (concat inputDir "/") ) )

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (myBuffer (ii 0) searchStr)

    (when (not (string-match "/xx" fPath))

      (setq myBuffer (get-buffer-create " myTemp"))
      (set-buffer myBuffer)
      (insert-file-contents fPath nil nil nil t)

      (setq case-fold-search nil) ; NOTE: remember to set case sensitivity here

      (setq searchStr "<div class=\"amz728x90\">" )

      (goto-char 1)
      (while (search-forward searchStr nil t) ; NOTE: remember to set regex or not
          (princ (format "this many: %d %s\n" (line-number-at-pos (point)) fPath))
        )
      
      (kill-buffer myBuffer)
      )
    ))

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*xah occur output*" )
  (with-output-to-temp-buffer outputBuffer 
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
  (princ "Done deal!")
    )
  )

