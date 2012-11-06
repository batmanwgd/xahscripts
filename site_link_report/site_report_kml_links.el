;-*- coding: utf-8 -*-

;; emacs lisp. emacs 22.

;; started: 2008-01-03.

;; generate a report of links to kml files.

;; this program traverse a given dir, visiting every html file, find links to kml files in those files, collect them, and generate a nice html report of these links and the files they are from, then write it to a given file.

; “~/web/xahlee_org/kml_links.html”

;;   Xah Lee
;; ∑ http://xahlee.org/


;;;; user level globle parameters

(defconst dirpath (expand-file-name "../xahlee_org/") "The dir to process.")

(defconst root-path-char-count (length dirpath)
  "A integer that counts how many chars to take off of a given file's full path, to result as a relative path for the link url. e.g. if file path is
“/Users/xah/web/emacs/emacs.html” , and root-path-char-count is 15, then its url in link would be “emacs/emacs.html”.
This number is not necessarily the length of dirpath. It can be smaller for flexibility.")

(defconst siteHeaderFilePath (expand-file-name "site_report_kml_links_header.txt") "The header text for xahlee.org.")

(defconst siteFooterFilePath (expand-file-name "site_report_kml_links_footer.txt") "The footer text for xahlee.org.")

(defconst output-file 
(concat (expand-file-name "../xahlee_org/") "kml_links.html")
  "The file to save the generated report to. (existing file backedup as ~)")

;;;; loading package. global vars.

(setq tmpBufName (concat " xahtemp" (int-to-string (random t)) ))

(require 'find-lisp)

;; create hash table.
;; for each entry, the key is Wikipedia url, and value is a list of file paths.
;; like this: ("Wikipedia url" ("file1" "file2" ...))
(setq kmlData-hash (make-hash-table :test 'equal :size 4000))

;; a list version of the hash for sorting & report
(setq kmlData-list '())


;;;; subroutines

(defun insert-date ()
  "Insert current date."
(interactive)
  (if (and (or delete-selection-mode cua-mode) mark-active)
       (delete-region (region-beginning) (region-end))
    )
  (insert (format-time-string "%Y-%m-%d"))
)

(defun hash-to-list (hashtable)
  "Return a list that represent the hashtable."
  (let (mylist)
    (maphash (lambda (kk vv) (setq mylist (cons (list kk vv) mylist))) hashtable)
    mylist))

(defun add-wplink-to-hash (filePath)
  "Get links in filePath and add it to hash table."
  (let (kmlFileName)

    (insert-file-contents filePath nil nil nil t)
    (goto-char (point-min))

    (while
        (re-search-forward
         "href=\"\\(\\.\\./[^\"]+\\)\\.kml\"" ; any local link starting with “../” and end in “.kml”
         nil t)

(message (match-string 1))
      (when (and
             (match-string 0) ; file found
             )

        (setq kmlFileName (concat (file-name-nondirectory (match-string 1)) ".kml") ) ; set kmlFileName to matched string

        ;; if exist in hash, prepend to existing entry, else just add
        (if (gethash kmlFileName kmlData-hash)
            (puthash kmlFileName (cons filePath (gethash kmlFileName kmlData-hash)) kmlData-hash)
          (puthash kmlFileName (list filePath) kmlData-hash))
        ))))


(defun prt-each (ele)
  "Print each item. ELE is of the form (url (filepath1 filepath2 ...)).
Print it like this:
<li> ‹link to url› : ‹link to file1›, ‹link to file2›, ...</li>"
  (let (kmlFileName files)
    (setq kmlFileName (car ele))
    (setq files (cadr ele))

    (insert "<li>")
    (insert (concat
             "<a href=\"kml/" kmlFileName  "\">"
             (get-kml-file-title (concat "~/web/xahlee_org/kml/" kmlFileName))
             "</a>"))

    (insert " —")

    (dolist (x files nil)
      (insert (concat " <a href=\"" (substring x root-path-char-count) "\">" (get-html-file-title x) "</a>,")))
    (delete-backward-char 1)

    (insert ".")
    (insert "</li>\n")

    )
  )



(defun get-html-file-title (fname)
"Return FNAME <title> tag's text.
Assumes that the file contains the string
“<title>…</title>”."
 (let (x1 x2 linkText)
   (with-temp-buffer
     (insert-file-contents fname nil nil nil t)
     (goto-char 1)
     (setq x1 (search-forward "<title>"))
     (search-forward "</title>")
     (setq x2 (search-backward "<"))
     (buffer-substring-no-properties x1 x2)
     )
   ))

(defun get-kml-file-title (fname)
"Return FNAME <title> tag's text.
Assumes that the file contains the string
“<title>...</title>”."
 (let (x1 x2 linkText)

   (with-temp-buffer
     (goto-char (point-min))
     (insert-file-contents fname nil nil nil t)

     (setq x1 (search-forward "<name>"))
     (search-forward "</name>")
     (setq x2 (search-backward "<"))
     (buffer-substring-no-properties x1 x2)
     )
   ))


;;;; main

;; backup
(when (file-exists-p output-file)
  (copy-file output-file (concat output-file "~") t)
  (delete-file output-file)
  )

;; get links from files, put to hash
(save-current-buffer
  (set-buffer (get-buffer-create tmpBufName))
  (let (filePaths)
    ;; get files ending in “.html” but not starting with “xx”.
    (mapcar 
     (lambda (x) (when (not (string-match "/xx" x))
                     (setq filePaths (cons x filePaths) )
                   ))
     (find-lisp-find-files dirpath "\\.html$"))
    (mapc 'add-wplink-to-hash filePaths)
    )
  
  (setq kmlData-list (hash-to-list kmlData-hash))
  (setq kmlData-list
        (sort kmlData-list 
              (lambda (a b) (string< (downcase (car a)) (downcase (car b))))
)))

;; print it out in a temp buffer and save to file
(switch-to-buffer tmpBufName)
(erase-buffer)
(insert-file-contents siteHeaderFilePath) (goto-char (point-max))

(insert "<h1>Google Earth Files on XahLee.org</h1>")
(insert "<p>This page contains all Google Earth files at XahLee.org, with links to the page the location is referenced. This file is generated on ")
(insert-date) 
(insert ". There are a total of " (number-to-string (length kmlData-list)) " Google Earth files.</p>\n\n")
(insert "<ul>")
(mapcar 'prt-each kmlData-list)
(insert "</ul>")
(insert "\n\n")
(insert "<div class=\"rltd\">
<ul>
<li><a href=\"wikipedia_links.html\">Links to Wikipedia from XahLee.org</a></li>
</ul>
</div>")
(insert "\n\n")

(insert-file-contents siteFooterFilePath) (goto-char (point-max))

(write-file output-file)

(clrhash kmlData-hash)
(setq kmlData-list '())
