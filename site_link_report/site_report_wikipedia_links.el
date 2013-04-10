;-*- coding: utf-8 -*-
;; emacs lisp. emacs 22.

;; started: 2008-01-03.
;; version: 2011-07-22

;; generate a report of wikipedia links.

;; this program traverse a given dir, visiting every html file, find links to Wikipedia in those files, collect them, and generate a nice html report of these links and the files they are from, then write it to a given file.

;; http://xahlee.org/wikipedia_links.html

;;   Xah Lee
;; ∑ http://xahlee.org/


;;;; user level globle parameters

;; command line args (inputs): ξ-inputDir

;; webRootDir is the dir of web root.

;; Behavior:
;; generate all links of files in that dir.
;; output these links in a file named “wikipedia_links.html” at the ξ-inputDir. (if the file exist, it is backup with “~” appended.) The URL base of these links will be web root.

;; Does not assume the environment variable HOME is set. No other assumption made.

(defvar ξ-inputDir "" "The dir to process.")
(setq ξ-inputDir (expand-file-name  "~/web/") )


(if (elt argv 0)
    (setq ξ-inputDir (elt argv 0) )
  )

(defvar ξ-outputFilename "" "The file name to save the generated report to.")
(setq ξ-outputFilename "wikipedia_links.html")

;; add a ending slash to ξ-inputDir if not there
(when (not (string= "/" (substring ξ-inputDir -1) )) (setq ξ-inputDir (concat ξ-inputDir "/") ) )

(defconst ξ-outputFileFullpath
(concat (expand-file-name  "~/web/") "xahlee_org/" ξ-outputFilename)
  "The file to save the generated report to. (existing file backedup as ~)")

(when (not (file-exists-p ξ-inputDir)) (error "input dir does not exist: %s" ξ-inputDir))

(defconst root-path-char-count (length ξ-inputDir)
  "A integer that counts how many chars to take off of a given file's full path, to result as a relative path for the link url. e.g. if file path is
“/Users/xah/web/emacs/emacs.html” , and root-path-char-count is 15, then its url in link would be “emacs/emacs.html”.
This number is not necessarily the length of ξ-inputDir. It can be smaller for flexibility.
2011-07-22 TODO: questionable feature here. Do not rely on it.
")

(defconst ξ-siteHeaderFilePath (fullpath-relative-to-current-file "site_report_wikipedia_links_header.txt") "The header text for xahlee.org.")

(defconst ξ-siteFooterFilePath (fullpath-relative-to-current-file "site_report_wikipedia_links_footer.txt") "The footer text for xahlee.org.")


;;;; loading package. global vars.

(require 'find-lisp)
(require 'xeu_elisp_util)

;; create hash table.
;; for each entry, the key is Wikipedia url, and value is a list of file paths.
;; like this: ("Wikipedia url" ("file1" "file2" …))
(setq wpdata-hash (make-hash-table :test 'equal :size 8000))

;; a list version of the hash for sorting & report
(setq wpdata-list '())


;;;; subroutines

(defun add-wplink-to-hash (filePath hashTableVar)
  "Get links in filePath and add it to hash table at the variable hashTableVar."
  (let ( ξwp-url)
    (with-temp-buffer
      (insert-file-contents filePath nil nil nil t)
      (goto-char 1)
      (while
          (re-search-forward
           "href=\"\\(http://..\\.wikipedia\\.org/[^\"]+\\)\">\\([^<]+\\)</a>"
           nil t)
        (setq ξwp-url (match-string 1))
        (when (and
               ξwp-url ; if url found
               (not (string-match "=" ξwp-url )) ; do not includes links that are not Wikipedia articles. e.g. user profile pages, edit history pages, search result pages
               (not (string-match "%..%.." ξwp-url )) ; do not include links that's lots of unicode
               )

          ;; if exist in hash, prepend to existing entry, else just add
          (if (gethash ξwp-url hashTableVar)
              (puthash ξwp-url (cons filePath (gethash ξwp-url hashTableVar)) hashTableVar) ; not using add-to-list because each Wikipedia URL likely only appear once per file
            (puthash ξwp-url (list filePath) hashTableVar)) )) ) ) )

(defun ξ-print-each (ele)
  "Print each item. ELE is of the form (url (list filepath1 filepath2 …)).
Print it like this:
‹link to url› : ‹link to file1›, ‹link to file2›, …"
  (let (wplink files)
    (setq wplink (car ele))
    (setq files (cadr ele))

    (insert (wikipedia-url-to-linktext wplink))
    (insert "—")

    (dolist (xx files nil)
      (insert
       (format "<a href=\"%s\">%s</a>◇"
               (xahsite-filepath-to-href-value xx ξ-outputFileFullpath )
               (get-html-file-title xx)
               )))
    (delete-char -1)
    (insert "\n")

    )
  )



(defun wikipedia-url-to-linktext (url)
  "Return the title of a Wikipedia link.
Example:
http://en.wikipedia.org/wiki/Emacs
becomes
Emacs"
  (let ((linktext url))
    (require 'gnus-util)
    (setq linktext (gnus-url-unhex-string linktext nil))
    (setq linktext (concat (car (last (split-string linktext "/")))) )
    (setq linktext (replace-regexp-in-string "&" "＆" linktext))
    (setq linktext (replace-regexp-in-string "_" " " linktext))
    linktext)
)

(defun wikipedia-url-to-link (url)
  "Return the url as html link string.\n
Example:
http://en.wikipedia.org/wiki/Emacs
becomes
<a href=\"http://en.wikipedia.org/wiki/Emacs\">Emacs</a>"
  (format "<a href=\"%s\">%s</a>" url (wikipedia-url-to-linktext url))
)


;;;; main

;; fill wpdata-hash
(let (filePaths)
  (setq filePaths '()) ; all files to process
  ;; get files ending in “.html” but not starting with “xx”.
  (mapc
   (lambda ( ξx) (when
                     (and
                      (not (string-match "/xx" ξx))
                      (not (string-match "emacs_manual/emacs/" ξx))
                      (not (string-match "emacs_manual/elisp/" ξx))
                      )
                   (setq filePaths (cons ξx filePaths) )
                   ))
   (find-lisp-find-files ξ-inputDir "\\.html$"))

  (mapc
   (lambda (ξx) (add-wplink-to-hash ξx wpdata-hash ))
   filePaths)
  )

;; fill wpdata-list
(setq wpdata-list (hash-to-list wpdata-hash))
(setq wpdata-list
      (sort wpdata-list
            (lambda (a b) (string< (downcase (car a)) (downcase (car b))))
            ))


;; backup existing output file
(when (file-exists-p ξ-outputFileFullpath)
  (copy-file ξ-outputFileFullpath (concat ξ-outputFileFullpath "~") t)
  ;; (delete-file ξ-outputFileFullpath)
  )

;; write to file
(with-temp-file ξ-outputFileFullpath
  (insert-file-contents ξ-siteHeaderFilePath)
  (goto-char (point-max))

  (insert
   "<h1>Links To Wikipedia from XahLee.org</h1>\n\n"
   "<p>This page contains all existing links from xah sites to Wikipedia, as of ")

  (insert (format-time-string "%Y-%m-%d"))

  (insert
   ". There are a total of " (number-to-string (length wpdata-list)) " links.</p>\n\n"
   "<p>This file is automatically generated by a <a href=\"http://ergoemacs.org/emacs/elisp_link_report.html\">emacs lisp script</a>.</p>

"
   )

  (insert "<div style=\"white-space:pre-wrap;width:100%\">\n")

  (mapc 'ξ-print-each wpdata-list)

  (insert "</div>")

  (insert "\n\n")

  (insert-file-contents ξ-siteFooterFilePath)
  (goto-char (point-max))
  )

;; clear memory
(clrhash wpdata-hash)
(setq wpdata-list '())

;; open the file
(find-file ξ-outputFileFullpath )
