;; -*- coding: utf-8 -*-
;; sync up xahlee.info from xahlee.org
;; 2009-09-10, 2011-04-02


(require 'xah-replace-pairs)


;; constants

(defvar sourceDir nil "Dir for XahLee.org")
(setq sourceDir "~/web/xahlee_org/")

(defvar destDir nil "Dir for xahlee.info.")
(setq destDir "~/web/xahlee_info/")

(defvar htaccessContent nil "root .htaccess file content for xahlee.info")
(setq htaccessContent (xah-get-string-from-file "xahlee.info .htaccess content.txt"))

(defvar templateText nil "template text for nsfw pages.")
(setq templateText (xah-get-string-from-file "porn_access_template.txt"))

(defvar findReplacePairsList nil "A list of replacement pairs. Each element is a vector of 2 elements. Each element is a string, from a file content.")

(setq findReplacePairsList
      (list
       (vector "['_setAccount', 'UA-10884311-2']" "['_setAccount', 'UA-10884311-1']")
       (vector (xah-get-string-from-file "t ad f chitika.txt") (xah-get-string-from-file "t ad r adsense.txt"))
       (vector (xah-get-string-from-file "t header f.txt") (xah-get-string-from-file "t header r.txt"))
       (vector (xah-get-string-from-file "t footer f.txt") (xah-get-string-from-file "t footer r.txt"))
       (vector
 "<script type=\"text/javascript\" src=\"http://xahlee.org/xlomain.js\"></script>"
 "<script type=\"text/javascript\" src=\"http://xahlee.info/xlomain.js\"></script>" )
       (vector "xahlee.org" "xahlee.info" )
 ))


;; functions

(defun replacePageContent (fpath)
  "Replace file content with a redirect message, if the file is nsfw or porn.

FPATH is a file on xahlee.info. e.g.
~/web/xahlee_info/bb/ox_horns.html

Example usage:
 (replacePageContent \"~/web/xahlee_info/bb/ox_horns.html\")

if the keyword line e.g.
<meta name=\"keywords\" content=\"hairdo, odango, double buns hairdo,丫头, nsfw\">
contain keywords nsfw or porn,
then, replace the content of the page between “body” tag to this template:

<p>The content of this page may be offensive.
If you still wish to see this page, please go to: http://xahlee.org/bb/ox_horns.html </p>"
  (let ( url p1 p2 kwds tmpStr )
    
    ;; open the file 
    (with-temp-file fpath
      (insert-file-contents fpath nil nil nil t)

      ;; get the keywords as a string
      (goto-char 1)
      (search-forward "<meta name=\"keywords\" content=\"" nil t)
      (setq p1 (point))
      (search-forward "\n")
      (setq p2 (point))
      (setq kwds (buffer-substring-no-properties p1 p2) )

      ;; do standard ad replacement.
      (progn (replace-pairs-region (point-min) (point-max) findReplacePairsList) )

      ;; check if the keywords contain nsfw or porn. If so, replace content with a redirect.
      (when (or
           (string-match "nsfw" kwds)
           (string-match "porn" kwds) )
          (progn 
            ;; get file url
            (setq url (replace-regexp-in-string 
                       "^c:/Users/h3/web/xahlee_info/"
                       "http://xahlee.org/" fpath))

            ;; remove the content between body tag
            (goto-char 1)
            (search-forward "<body>")
            (forward-char)
            (setq p1 (point))
            (goto-char (point-max))
            (search-backward "</body>")
            (backward-char)
            (setq p2 (point))
            (delete-region p1 p2)

            ;; insert a new content
            (setq tmpStr (replace-regexp-in-string "〚title〛" (get-html-file-title fpath) templateText t t))
            (setq tmpStr (replace-regexp-in-string "〚url〛" url tmpStr t t))
            (insert tmpStr)
            )
         ) ) ) )


;;;; main

;; copy xahlee_org  dir to xahlee_info
(princ "Copying by rsync from xahlee.org to xahlee.info dir …")
(shell-command (concat "rsync --compress --perms --recursive --times --exclude=\"*~\" --exclude=\"**/xx*\" --delete  " sourceDir " " destDir ) )

;; ;; replace paypal donation lines by google adsense lines
;; (princ "Replacing donation box by AdSense. Calling python script …")
;; (shell-command "python replace_xahlee_site_ads.py")

(let (outputBuffer)
  (setq outputBuffer "*update xahlee.info output*" )
  (with-output-to-temp-buffer outputBuffer 

    ;; change pages that i don't want to have google ad; and replace various ads, donation etc by google adsense or other
    (require 'find-lisp)
    (mapc 'replacePageContent (find-lisp-find-files destDir "\.html$"))

    ;; replace content of the file “.htaccess” at root
    (princ "Modifing root .htaccess …\n")
    (find-file (concat destDir ".htaccess") )
    (erase-buffer)
    (insert htaccessContent )
    (save-buffer)
    (kill-buffer)

    ;; replace content of the file “robots.txt” at root
    (princ "Modifing robots.txt …\n")
    (find-file (concat destDir "robots.txt") )
    (goto-char (point-min))
    (while (search-forward "xahlee.org" nil t) (replace-match "xahlee.info"))
    (save-buffer)
    (kill-buffer)

    ;; replace content of the file “header.html” at root
    (princ "Modifing header.html …\n")
    (find-file (concat destDir "header.html") )
    (goto-char (point-min))
    (while (search-forward "xahlee.org" nil t) (replace-match "xahlee.info"))
    (save-buffer)
    (kill-buffer)

    ;; replace content of the file “footer.html” at root
    (princ "Modifing footer.html …\n")
    (find-file (concat destDir "footer.html") )
    (goto-char (point-min))
    (while (search-forward "xahlee.org" nil t) (replace-match "xahlee.info"))
    (save-buffer)
    (kill-buffer)

    ;; replace content of the file “xlomain.js” at root
    (princ "Modifing xlomain.js …\n")
    (find-file (concat destDir "xlomain.js") )
    (goto-char (point-min))
    (while (search-forward "xahlee.org" nil t) (replace-match "xahlee.info"))
    (save-buffer)
    (kill-buffer)

    ;; replace xahlee.org by xahlee.info in sitemap.xml.gz
    (shell-command (concat "gzip -d " destDir "sitemap.xml.gz"))
    (find-file (concat destDir "sitemap.xml"))
    (goto-char (point-min))
    (while (search-forward "<url><loc>http://xahlee.org/" nil t) (replace-match "<url><loc>http://xahlee.info/"))
    (save-buffer)
    (kill-buffer)
    (shell-command (concat "gzip " destDir "sitemap.xml"))

    (princ "Updating XahLee.info done.")

    ) )
