; -*- coding: utf-8 -*-
; 2010-08-08

;; given a list of files, change their nav bar to point to a particular path.

;; the new navbar destination
(setq newNavBarTopFilePath "~/web/xahlee_org/Periodic_dosage_dir/skami_prosa.html" ) 

;; files to process
(setq filesToProcess '(
"~/web/xahlee_org/emacs/emacs.html"
"~/web/xahlee_org/perl-python/index.html"
"~/web/xahlee_org/java-a-day/java.html"
"~/web/xahlee_org/js/index.html"
"~/web/xahlee_org/ocaml/ocaml.html"
"~/web/xahlee_org/php/index.html"
"~/web/xahlee_org/powershell/index.html"
) )

; open a file, process it
(defun my-process-file (fPath)
  "Process the file at path FPATH …"

(let (p1 p2 currentFname title newNavbarRelativePath newNavBarStr)

  (princ (format "Processing: %s\n" fPath))
  (find-file fPath )
  (goto-char 1)
  (search-forward "<div class=\"nav\">")
  (beginning-of-line )
  (setq p1 (point) )
  (sgml-skip-tag-forward 1)
  (setq p2 (point) )

  (setq title (get-html-file-title newNavBarTopFilePath) )
  (setq newNavbarRelativePath (file-relative-name newNavBarTopFilePath))
  (setq newNavBarStr (concat  "<div class=\"nav\">▲ " "<a href=\"" newNavbarRelativePath "\">" title "</a>.</div>" ))

  (delete-region p1 p2 )
  (insert newNavBarStr)
  ) )


(let (outputBuffer)
  (setq outputBuffer "*change nav bar output*" )
  (with-output-to-temp-buffer outputBuffer 
    (mapc 'my-process-file filesToProcess)
    (princ "Done deal!") ) )
