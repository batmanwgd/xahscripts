;; -*- coding: utf-8 -*-
;; 2010-03-27, 2012-03-18
;; report how many occurances of a string
;; the string must occur within some other string

(setq inputDir "~/web/xahlee_org/" ) ; dir should end with a slash

(require 'sgml-mode)

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (myBuffer p1 p2 ξmeat (ξi 0))

    (when (and (not (string-match "/xx" fPath))
               )

      (setq myBuffer (get-buffer-create " myTemp"))
      (set-buffer myBuffer)
      (insert-file-contents fPath nil nil nil t)

      (goto-char 1)

      (while
          ;; (search-forward-regexp "xahh-20\">\\([^<]+?\\)</a>"  nil t)
          ;; (setq ξmeat (match-string 1 ))

          (search-forward "<div class=\"rltd\">"  nil t)
        (backward-char 1)

        ;; capture text i'm interested
        (setq p1 (point))
        (sgml-skip-tag-forward 1)
        (setq p2 (point))
        ;; (setq ξmeat (buffer-substring-no-properties p1 p2))

        (setq ξi (count-matches "<ul>" p1 p2) )
        (when (> ξi 1)
          (princ (format "this many: %d %s\n" ξi fPath))
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

