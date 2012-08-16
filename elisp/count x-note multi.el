;; -*- coding: utf-8 -*-
;; 2011-02-25
;; print files that meet this condition:
;; contains <div class="x-note">…</div>
;; where the text content contains more than one bullet char •

(setq inputDir "~/web/xahlee_org/" ) ; dir should end with a slash
(setq inputDir "~/web/xahlee_org/p/" ) ; dir should end with a slash

(require 'sgml-mode) ; need sgml-skip-tag-forward

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (myBuffer 
p3 p4  (bulletCnt 0) (totalCnt 0)
)

    (when (and (not (string-match "/xx" fPath))
               )

      (setq myBuffer (get-buffer-create " myTemp"))
      (set-buffer myBuffer)
      (insert-file-contents fPath nil nil nil t)

      (setq bulletCnt 0 ) 
      (goto-char 1)
      (while
          (search-forward "<div class=\"x-note\">"  nil t)

        (setq p3 (point) ) ; beginning of text content, after <div class="x-note">
        (backward-char)
        (sgml-skip-tag-forward 1)
        (backward-char 6)
        (setq p4 (point) ) ; end of tag content, before the </div>

        (setq bulletCnt (count-matches "•" p3 p4) )

        (when (> bulletCnt 2)
          (setq totalCnt (1+ totalCnt) )
          (princ (format "this many: %d %s\n" bulletCnt fPath))
          )
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

