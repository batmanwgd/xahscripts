; -*- coding: utf-8 -*-
;; 2010-03-15

;; add keywords to certain pages

;; go thru a list of given files.
;; look at the keyword line
;; <meta name="keywords" content="hairdo, odango, double buns hairdo,丫头, nsfw">
;; if it does not contain certain keyword, add it (add the meta tag if it doesnt have it already)

(setq keywordToAdd "porn")

(setq inputFilePaths
(list

))

(setq inputDir "c:/Users/xah/web/xahlee_org/porn/" ) ; dir should end with a slash

; open a file, process it
(defun my-process-file (fpath)
  "process the file at fullpath fpath ..."
  (let (mybuffer (fileChanged-p nil))

    (when (and (not (string-match "/xx" fpath))
               (not (string-match "/more\\.html" fpath))
               )

      (setq mybuffer (get-buffer-create " myTemp"))
      (set-buffer mybuffer)
      (insert-file-contents fpath nil nil nil t)

      (goto-char 1)
      ;; check if file contains the keyword meta tag
      (if (search-forward "<meta name=\"keywords\" content=\"" nil t)

          ;; file does contain the keyword tag
        (let ( kwdPosStart kwdPosEnd kwdPosStart-line kwdPosEnd-line)
          ;; grab the keyword content begin/end positions
          (setq kwdPosStart (point))
          (when (search-forward "\">")
            (search-backward "\"")
            (setq kwdPosEnd (point))
            
            (setq kwdPosStart-line (line-number-at-pos kwdPosStart))
            (setq kwdPosEnd-line (line-number-at-pos kwdPosEnd))

            (when (not (= kwdPosStart-line kwdPosEnd-line)) ;; double check that that the keyword meta tag is one single line
                 (princ (format "Error %s\n" fpath))
            )

            ;; check if it contains the keyword. If not, add it.
            (when (not (string-match (regexp-quote keywordToAdd)
                                     (buffer-substring-no-properties kwdPosStart kwdPosEnd) ))
              (goto-char kwdPosEnd)
              (insert (concat ", " keywordToAdd))
              (setq fileChanged-p t)
              )
            )
          )

          ;; file does not contain the keyword tag
        (progn
          (goto-char 1)
          (search-forward "<link rel=\"stylesheet\"")
          (beginning-of-line)
          (insert "<meta name=\"keywords\" content=\"" keywordToAdd "\">\n")
          (setq fileChanged-p t)
          )
        )

      (when fileChanged-p (write-file fpath)
            (princ (format "◇Changed: %s\n" fpath))
            )
      (kill-buffer mybuffer)
      )
    ))


;; main

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*kwd added output*" )
  (with-output-to-temp-buffer outputBuffer 

    ;; if a file list is given, process those files, else, process all html files in a dir
    (if (not (= (length inputFilePaths) 0) )
        (mapc 'my-process-file inputFilePaths)
      (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
      )

    (princ "Keyword adding done. Any changed file are printed above.\n")
    (switch-to-buffer outputBuffer)
    )
  )