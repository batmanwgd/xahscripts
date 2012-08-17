; -*- coding: utf-8 -*-
;; 2010-03-15

;; list all pages that has particular keyword.

;; the keyword to search. Interpreted as regex
(setq myKeyword "nsfw" )

(setq inputDir "c:/Users/xah/web/xahlee_org/porn/" ) ; dir should end with a slash

; open a file, process it
(defun my-process-file (fpath)
  "process the file at fullpath fpath ..."
  (let (mybuffer (hasKeyword-p nil) )

    (when (and (not (string-match "/xx" fpath))
               )

      (setq mybuffer (get-buffer-create " myTemp"))
      (set-buffer mybuffer)
      (insert-file-contents fpath nil nil nil t)

      (goto-char 1)
      ;; check if file contains the keyword meta tag
      (when (search-forward "<meta name=\"keywords\" content=\"" nil t)
          (let (kwdPosStart kwdPosEnd)

            ;; grab the keyword content positions
            (setq kwdPosStart (point))
            (when (search-forward "\">")
              (search-backward "\"")
              (setq kwdPosEnd (point))

              (when (string-match myKeyword (buffer-substring-no-properties kwdPosStart kwdPosEnd) )
                (setq hasKeyword-p t) ) ) ) )

      (if hasKeyword-p
          (princ (format "◆Yes: %s\n" fpath))
        (princ (format "◇No: %s\n" fpath))
        )

      (kill-buffer mybuffer)
      )
    ))


;; main

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*keyword output*" )
  (with-output-to-temp-buffer outputBuffer 
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))

    (princ "Done.\n")
    (switch-to-buffer outputBuffer)
    )
  )
