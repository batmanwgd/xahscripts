;; -*- coding: utf-8 -*-

;; 2010-09-12

;; complex query replace.

;; find text of the pattern such as

; <A HREF="../Downloads/3DXplorMath10.5.5.dmg">Download 3D-XplorMath10.5.5</A>
; change it to this
; <A HREF="../Downloads/3DXplorMath10.5.5.dmg" onClick="javascript: pageTracker._trackPageview('/Downloads/3DXplorMath10.5.5.dmg'); ">Download 3D-XplorMath10.5.5</A>

; basically, add a Google Analytics's js tracking code linked files

(defun ff ()
  "temp function. Returns a string based on current regex match."
  (let (url title fFullPath replaceStr )
    (setq url (match-string 1) )
    (setq title (match-string 2) )

    ;; "c:/Users/xah/uci-server/odemath/PDF_Files/Preface.pdf"
    (setq fFullPath (concat (file-name-directory (or load-file-name buffer-file-name)) url ".pdf") )
    (setq newPath (substring fFullPath 31))

    (setq replaceStr
          (concat
           "<a href=\"" url ".pdf"  "\" onClick=\"javascript: pageTracker._trackPageview('"
           newPath
           "');\">"
           title
           "</a>" ) ) 
    replaceStr
    ) )

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (myBuffer url title fFullPath replaceStr fExt p7 p8 fullMatchText)
    (setq myBuffer (find-file fPath))
    (goto-char (point-min)) ;; in case buffer already open

    (when 
        (search-forward-regexp "<a href=\"\\([^\"]+?\\)\">\\([^<]+?\\)</a>" nil t)

      (progn 
        (setq fullMatchText (match-string 0) )
        (setq url (match-string 1) )
        (setq title (match-string 2) )
        (setq p7 (match-beginning 0) )
        (setq p8 (match-end 0) )

        (when (or 
               (string-match "\.pdf$" url)
               (string-match "\.mov$" url)
               ) 

          ;; "c:/Users/xah/uci-server/odemath/PDF_Files/Preface.pdf"
          (setq fFullPath (concat (file-name-directory (or load-file-name buffer-file-name)) url) )
          (setq newPath (substring fFullPath 31))
          (setq fExt (file-name-extension url))

          (setq replaceStr
                ;; pdf mov
                (concat 
                 "<a href=\"" url  " onClick=\"javascript: pageTracker._trackPageview('"
                 newPath
                 "');\">"
                 title
                 "</a>" ) )

          (if (y-or-n-p "replace?") 
              (progn 
                (delete-region p7 p8 )
                (insert replaceStr)
                )
            (progn (kill-buffer myBuffer))
            )
          )
        )

      (progn (kill-buffer myBuffer))

      ) ) )

(require 'find-lisp)
(mapc 'my-process-file (find-lisp-find-files "~/uci-server/odemath/" "\\.html$"))



(defun ff (from to &optional delimited)
  "Do `query-replace-regexp' of FROM with TO, on all marked files.
Third arg DELIMITED (prefix arg) means replace only word-delimited matches.
If you exit (\\[keyboard-quit], RET or q), you can resume the query replace
with the command \\[tags-loop-continue]."
  (interactive
   (let ((common
	  (query-replace-read-args
	   "Query replace regexp in marked files" t t)))
     (list (nth 0 common) (nth 1 common) (nth 2 common))))
  (dolist (file (dired-get-marked-files nil nil 'dired-nondirectory-p))
    (let ((buffer (get-file-buffer file)))
      (if (and buffer (with-current-buffer buffer
			buffer-read-only))
	  (error "File `%s' is visited read-only" file))))
  (tags-query-replace from to delimited
		      '(dired-get-marked-files nil nil 'dired-nondirectory-p)))


<a href="\([^"]+?\)">\([^<]+?\)</a>

<a href="\([^.]+?\)\.pdf">\([^<]+?\)</a>

<a href="\1.pdf" onClick="javascript: pageTracker._trackPageview('\1.pdf');">\2</a>

<A HREF="../Downloads/3DXplorMath10.5.5.dmg" onClick="javascript: pageTracker._trackPageview('/Downloads/3DXplorMath10.5.5.dmg'); ">Download 3D-XplorMath10.5.5</A>
