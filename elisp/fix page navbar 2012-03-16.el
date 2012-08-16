;; -*- coding: utf-8 -*-
;; 2012-03-16

;; a script that reports bad links in a page nav section.

;; here's a sample page nav bar section:

;; <div id="pnavbar">
;; <a href="barda_karce.html" title="Vans, Monster Trucks, 18-Wheelers — Bigger IS Better">1</a>
;; 2
;; <a href="karce2.html" title="Star Spangled Cars">3</a>
;; <a href="flag_bike.html" title="Star Spangled Bikes">4</a>
;; </div>

;; 
;; for each html file in a dir
;; find the string 「<div id="pnavbar">」
;; grab the tag content
;; check if the file name occur inside. (because the page nav bar shouldn't have current file as link)
;; if so, print this file's name.

(setq inputDir "~/web/xahlee_org/" ) ; must end with a slash

;; add a ending slash if not there
(when (not (string= "/" (substring inputDir -1) )) (setq inputDir (concat inputDir "/") ) )

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let ((ξi 0) searchStr1
        p1 p2
        )
    (when (not (string-match "/xx" fPath))
      (with-temp-buffer
        (insert-file-contents fPath)

        (setq searchStr1 "<div id=\"pnavbar\">" )

        (goto-char 1)
        (setq case-fold-search nil) ; NOTE: remember to set case sensitivity here
        (while (search-forward searchStr1 nil t) ; NOTE: remember to set regex or not
          (setq ξi (1+ ξi))

          (setq p1 (point) )
          (backward-char)
          (sgml-skip-tag-forward 1)
          (backward-char 6)
          (setq p2 (point) )

          (when
              (string-match (regexp-quote (file-name-nondirectory fPath )) (buffer-substring-no-properties p1 p2) )
            (princ (format "problem: %s\n" fPath)) ) ) ) ) ))

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*xah occur output*" )
  (with-output-to-temp-buffer outputBuffer
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )
