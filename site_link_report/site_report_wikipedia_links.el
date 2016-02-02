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

;; command line args (inputs): ξinputDir

;; webRootDir is the dir of web root.

;; Behavior:
;; generate all links of files in that dir.
;; output these links in a file named “wikipedia_links.html” at the ξinputDir. (if the file exist, it is backup with “~” appended.) The URL base of these links will be web root.

;; Does not assume the environment variable HOME is set. No other assumption made.

(defvar γ-inputDir nil "The dir to process")
(setq γ-inputDir (expand-file-name  "~/web/") )

(defvar γ-outputFilename nil "The file name to save the generated report to.")
(setq γ-outputFilename "wikipedia_links.html")

(defvar γ-outputFileFullpath nil "The file to save the generated report to. (existing file backedup as ~)")
(setq γ-outputFileFullpath (concat (expand-file-name  "~/web/") "xahlee_org/" γ-outputFilename))



(if (elt argv 0)
    (setq γ-inputDir (elt argv 0) )
  )

;; add a ending slash to γ-inputDir if not there
(when (not (string= "/" (substring γ-inputDir -1) )) (setq γ-inputDir (concat γ-inputDir "/") ) )

(when (not (file-exists-p γ-inputDir)) (error "input dir does not exist: %s" γ-inputDir))

(defconst root-path-char-count (length γ-inputDir)
  "A integer that counts how many chars to take off of a given file's full path, to result as a relative path for the link url. e.g. if file path is
“/Users/xah/web/emacs/emacs.html” , and root-path-char-count is 15, then its url in link would be “emacs/emacs.html”.
This number is not necessarily the length of γ-inputDir. It can be smaller for flexibility.
2011-07-22 TODO: questionable feature here. Do not rely on it.
")

(defconst γ-siteHeaderFilePath (xah-get-fullpath "site_report_wikipedia_links_header.txt") "The header text for xahlee.org.")

(defconst γ-siteFooterFilePath (xah-get-fullpath "site_report_wikipedia_links_footer.txt") "The footer text for xahlee.org.")


;;;; loading package. global vars.

(require 'find-lisp)
(require 'xeu_elisp_util)

(defvar γ-wpdata-hash nil "hash table. for each entry, the key is string Wikipedia url, value is a list of file paths.")
(setq γ-wpdata-hash (make-hash-table :test 'equal :size 8000))

(defvar γ-wpdata-list nil "a list version of the hash for sorting & report")


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
  (let (ξwplink ξfiles)
    (setq ξwplink (car ele))
    (setq ξfiles (cadr ele))

    (insert "<li>")
    (insert (wikipedia-url-to-linktext ξwplink))
    (insert "—")

    (dolist (xx ξfiles nil)
      (insert
       (format "<a href=\"%s\">%s</a>•"
               (xahsite-filepath-to-href-value xx γ-outputFileFullpath )
               (xah-html-get-html-file-title xx))))
    (delete-char -1)
    (insert "</li>\n"))
  )



(defun wikipedia-url-to-linktext (φurl)
  "Return the title of a Wikipedia link.
Example:
http://en.wikipedia.org/wiki/Emacs
becomes
Emacs"
  (require 'url-util)
  (decode-coding-string
   (url-unhex-string
    (replace-regexp-in-string
     "_" " "
     (replace-regexp-in-string
      "&" "＆"
      (car
       (last
        (split-string
         φurl "/")))))) 'utf-8))

(defun wikipedia-url-to-link (φurl)
  "Return the φurl as html link string.\n
Example:
http://en.wikipedia.org/wiki/Emacs
becomes
<a href=\"http://en.wikipedia.org/wiki/Emacs\">Emacs</a>"
  (format "<a href=\"%s\">%s</a>" φurl (wikipedia-url-to-linktext φurl))
)


;;;; main

;; fill γ-wpdata-hash
(let (ξfilePaths)
  (setq ξfilePaths '()) ; all files to process
  ;; get files ending in “.html” but not starting with “xx”.
  (mapc
   (lambda ( ξx) (when
                     (and
                      (not (string-match "/xx" ξx))
                      (not (string-match "emacs_manual/emacs/" ξx))
                      (not (string-match "emacs_manual/elisp/" ξx))
                      )
                   (setq ξfilePaths (cons ξx ξfilePaths) )
                   ))
   (find-lisp-find-files γ-inputDir "\\.html$"))

  (mapc
   (lambda (ξx) (add-wplink-to-hash ξx γ-wpdata-hash ))
   ξfilePaths)
  )

;; fill γ-wpdata-list
(setq γ-wpdata-list (xah-hash-to-list γ-wpdata-hash))
(setq γ-wpdata-list
      (sort γ-wpdata-list
            (lambda (a b) (string< (downcase (car a)) (downcase (car b))))
            ))

;; backup existing output file
(when (file-exists-p γ-outputFileFullpath)
  (copy-file γ-outputFileFullpath (concat γ-outputFileFullpath "~") t)
  ;; (delete-file γ-outputFileFullpath)
  )

;; write to file
(with-temp-file γ-outputFileFullpath
  (insert-file-contents γ-siteHeaderFilePath)
  (goto-char (point-max))

  (insert
   "<h1>Links To Wikipedia from XahLee.org</h1>\n\n"
   "<p>This page contains all existing links from xah sites to Wikipedia, as of ")

  (insert (format-time-string "%Y-%m-%d"))

  (insert
   ". There are a total of " (number-to-string (length γ-wpdata-list)) " links.</p>\n\n"
   "<p>This file is automatically generated by a <a href=\"http://ergoemacs.org/emacs/elisp_link_report.html\">emacs lisp script</a>.</p>

"
   )

  (insert "<ol>\n")

  (mapc 'ξ-print-each γ-wpdata-list)

  (insert "</ol>")

  (insert "\n\n")

  (insert-file-contents γ-siteFooterFilePath)
  (goto-char (point-max))
  )

;; clear memory
(clrhash γ-wpdata-hash)
(setq γ-wpdata-list '())

;; open the file
(find-file γ-outputFileFullpath )
