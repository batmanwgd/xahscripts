;; -*- coding: utf-8 -*-
;; 2011-03-20
;; change title to h1 tag's text in “Time Machine” pages
;; 
;; for each html page in 〔~/web/xahlee_org/p/Gullivers_Travels/〕
;; if the title tag and h1 tag text differ, make the title use h1's text

(setq inputDir "~/web/xahlee_org/p/Gullivers_Travels/" ) ; dir must end with a slash

(defun get-html-file-title (fname)
"Return FNAME <title> tag's text.
Assumes that the file contains the string
“<title>…</title>”."
 (let (x1 x2 linkText)

   (with-temp-buffer
     (goto-char 1)
     (insert-file-contents fname nil nil nil t)

     (setq x1 (search-forward "<title>"))
     (search-forward "</title>")
     (setq x2 (search-backward "<"))
     (buffer-substring-no-properties x1 x2)
     )
   ))

(defun get-html-file-h1-text (fname)
  "Return FNAME <h1> tag's text.
Assumes that the file contains the string
“<h1>…</h1>”."
  (let (x1 x2 linkText)

    (with-temp-buffer
      (goto-char 1)
      (insert-file-contents fname nil nil nil t)

      (setq x1 (search-forward "<h1>"))
      (search-forward "</h1>")
      (setq x2 (search-backward "<"))
      (buffer-substring-no-properties x1 x2)
      )
    ))

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let ( titleText h1Text p1 p2)

    (setq h1Text (get-html-file-h1-text fPath))
    (setq titleText (get-html-file-title fPath))

    (if (equal h1Text titleText)
        nil
      (progn 
        (find-file fPath )
        (goto-char 1)
        (search-forward "<title>" )
        (setq p1 (point) )

        (search-forward "</title>" )
        (backward-char 8)
        (setq p2 (point) )

        (delete-region p1 p2 )
        (insert h1Text)
        (print fPath)
        ))
    ))

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*output: change title h1 tags*" )
  (with-output-to-temp-buffer outputBuffer 
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )


