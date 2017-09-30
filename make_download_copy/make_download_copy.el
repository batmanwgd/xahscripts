;; -*- coding: utf-8; lexical-binding: t; -*-
;; first version 2008-06-12

;; make a downloadable copy of my website. See function “xah-make-downloadable-copy”
;; this is personal code.
;; Works in unix, and relies on my particular dir structure.

;; if on Windows, needs unix shell util installed, e.g. cygwin, and needs to be tweaked on file path, such as “/Users/xah” to “C:/Users/xah”
;; Xah Lee
;; ∑ http://xahlee.org/

;; todo

;; • possibly get rid of unix dependence. i.e. eliminate shell-command call. Write a elisp function delete-directory-recursive, and find elisp replacements for various “find ... rm {} \;” calls.
;; • get rid of hard-coded paths. e.g. “(copy-file "C:/Users/xah/web/xahlee_org/lang.css" destDir)”. Define global constants instead.
;; • bug: links to some files such as “c:/Users/xah/web/xahlee_org/kml/Aapua_wind_park.kmz”, are not created in the copy.
;; • bug: image links to dir outside of the copy dir are not copied.

(load-file "~/git/xah_emacs_init/xah_emacs_xahsite_path_lisp_util.el")

(require 'find-lisp)
(require 'subr-x)


;;;; functions

;; (xah-substract-path "c:/Users/lisa/web/a/b" "c:/Users/lisa/web/")

;; (require 'subr-x)
;; (string-remove-prefix "c:/Users/lisa/web/" "c:/Users/lisa/web/a/b")

;; (defun xah-substract-path (*path1 *path2)
;;   "Remove string *path2 from the beginning of *path1.
;; length of *path1 ≥ to length *path2.

;; path1
;; c:/Users/lisa/web/a/b

;; path2
;; c:/Users/lisa/web/

;; result
;; a/b

;; This is the similar to emacs 24.4's `string-remove-prefix' from (require 'subr-x), but the args are reversed.
;; Version 2015-12-15"
;;   (let ((-p2length (length *path2)))
;;     (if (string= (substring *path1 0 -p2length) *path2 )
;;         (substring *path1 -p2length)
;;       (error "error 34689: beginning doesn't match: 「%s」 「%s」" *path1 *path2))))



;; (xah-get-full-url "~/web/xahlee_org/emacs/emacs.html" "../Periodic_dosage_dir/skami_prosa.html" "~/web/xahlee_org/" "xahlee.org")

(defun xah-get-full-url (*-file-path *-linkpath *-web-doc-root *-host-name)
  "Returns a “http://” based URL of a given *-linkpath, based on its *-file-path, and {*-web-doc-root, *-host-name}.

*-file-path is the full path to a html file.
*-linkpath is a string that's relative path to *-file-path. e.g. 「<a href=\"‹*-linkpath›\">」.
*-web-doc-root is the path to a ancestor dir of *-file-path (i.e. it should be part of start of *-file-path).

Returns a URL of the form “http://‹*-host-name›/‹urlPath›” that points to the same file as *-linkpath.

For example:
 (xah-get-full-url
 \"/Users/xah/web/xahlee_org/Periodic_dosage_dir/t2/mirrored.html\"
 \"../../p/demonic_males.html\"
 \"/Users/xah/web/xahlee_org/\"
 \"xahlee.org\"
 )
Returns
 「\"http://xahlee.org/xahlee_org/p/demonic_males.html\"」

Note that *-web-doc-root may or may not end in a slash."
  (concat "http://" *-host-name "/"
          (substring
           (expand-file-name (concat (file-name-directory *-file-path) *-linkpath))
           (length (file-name-as-directory (directory-file-name (expand-file-name *-web-doc-root)))))))

(defun xah-drop-last-slash (*-path)
  "Remove the last *-path separated by “/”.
For example:
“/a/b/c/d” → “/a/b/c”
“/a/b/c/d/” → “/a/b/c/d”
“/” → “”
“//” → “/”
“” → “”"
  (if (string-match "\\(.*/\\)+" *-path)
      (substring *-path 0 (1- (match-end 0)))
    *-path))

(defun xah-copy-dir-single-level (*-sourcedir *-destdir)
  "Copy all files from *-SOURCEDIR to *-DESTDIR.

The input dir should not end in a slash.
Example usage:
 (xah-copy-dir-single-level
 \"/Users/xah/web/p/um\"
 \"/Users/xah/web/diklo/xx\")

Note: no consideration is taken about links, alias, or file perms."
  (mapc
   (lambda (-x)
     (when (and (not (string-equal -x ".")) (not (string-equal -x "..")))
       (copy-file
        (concat *-sourcedir "/" -x) *-destdir)))
   (directory-files *-sourcedir)))

(defun xah-delete-xahtemp-files (*-dir-path)
   "Delete some files and dirs in dir *-dir-path.
*-dir-path must be full path.

File/Dir deleted are file/dir names that:

• start with xx
• ends with ~
• #…#
• .DS_Store
  etc."
   (progn
     ;; remove emacs backup files, temp files, mac os x files, etc.
     (princ "Removing temp files…\n")
     (xah-delete-files-by-regex *-dir-path "\\`\\.htaccess\\'")
     (xah-delete-files-by-regex *-dir-path "\\`#.?+#\\'")
     (xah-delete-files-by-regex *-dir-path "\\`xx")
     (xah-delete-files-by-regex *-dir-path "\\`\\.DS_Store\\'")
     (xah-delete-files-by-regex *-dir-path "~\\'")

     ;; (expand-file-name *-dir-path)

     (shell-command "find . -depth -type d -name 'xx*' -exec rm {} ';'") ; TODO: stop calling shell command. use elisp instead
     ))

(defun xah-process-file-for-download (*-file-path *-original-file-path webRoot)
  "Modify the HTML file at *-file-path, to make it ready for download bundle.

This function change local links to “http://” links, Delete the google javascript snippet, and other small changes, so that the file is nicer to be viewed off-line at some computer without the entire xahlee.org's web dir structure.

The google javascript is the Google Analytics webbug that tracks web stat to xahlee.org.

*-file-path is the full path to the html file that will be processed.
*-original-file-path is full path to the “same” file in the original web structure.
*-original-file-path is used to construct new relative links."
  (let ( -p1 -p2 -hrefValue
             default-directory
             (case-fold-search nil))

    (with-temp-file *-file-path
      (insert-file-contents *-file-path)
      (goto-char 1)

      ;; (xahsite-remove-ads (point-min) (point-max))

      ;; go thru each link, if the link is local, then check if the file exist. if not, replace the link with proper http://xahlee.org/ url
      (goto-char 1)
      (while (search-forward-regexp "<a href=\"" nil t)

        (progn
          (setq -p1 (point))
          (search-forward "\"")
          (backward-char)
          (setq -p2 (point))
          (setq -hrefValue (buffer-substring-no-properties -p1 -p2))
          ;; (message "-hrefValue is 「%s」" -hrefValue)
          )

        (when (xahsite-local-link-p -hrefValue)
          (setq default-directory (file-name-directory *-file-path))
          (when (not (file-exists-p (elt (xah-html-split-uri-hashmark -hrefValue) 0)))
            (delete-region -p1 -p2)
            (insert
             ;; (xahsite-filepath-to-href-value (xahsite-href-value-to-filepath -hrefValue *-original-file-path) *-original-file-path)
             (xah-get-full-url *-original-file-path -hrefValue webRoot (xahsite-get-domain-of-local-file-path *-original-file-path))))))

      (goto-char 1)
      (while (search-forward-regexp "<img src[[:blank:]]*=[[:blank:]]*" nil t)

        (progn
          (forward-char 1)
          (setq -p1 (point))
          (search-forward "\"")
          (setq -p2 (- (point) 1))
          (setq -hrefValue (buffer-substring-no-properties -p1 -p2))
          ;; (message "-hrefValue is 「%s」" -hrefValue)
          )

        (when (xahsite-local-link-p -hrefValue)
          (setq default-directory (file-name-directory *-file-path))
          (when (not (file-exists-p -hrefValue))
            (delete-region -p1 -p2)
            (insert (xah-get-full-url *-original-file-path -hrefValue webRoot (xahsite-get-domain-of-local-file-path *-original-file-path)))))))))

(defun xah-make-downloadable-copy (*web-doc-root *source-dir-list *dest-dir )
  "Make a copy of a set of subdirs of Xah Site, for download.

All paths must be full paths.
All dir paths should end in slash.

• *web-doc-root is the website doc root dir. e.g. “/Users/xah/web/xahlee_org/”

• *source-dir-list is a list/sequence of dir paths to be copied for download. e.g.
 [\"/Users/xah/web/xahlee_org/emacs/\" \"/Users/xah/web/xahlee_org/comp/\" ]
Each path should be a subdir of *web-doc-root.

• *dest-dir is the destination dir. e.g.
 “/Users/xah/web/xahlee_org/diklo/emacs_tutorial_2012-05-05”
if exist, it'll be overridden.
"
  (let (
        ;; add ending slash, to be safe
        (-root (file-name-as-directory (expand-file-name *web-doc-root)))
        (-sourceDirList (mapcar (lambda (-x) (file-name-as-directory (expand-file-name -x))) *source-dir-list))
        (-destDir (file-name-as-directory (expand-file-name *dest-dir))))

    (princ "-sourceDirList")
    (princ -sourceDirList)

    ;; copy to destination
    (mapc
     (lambda (-oneSrcDir)
       (let ((-fromDir -oneSrcDir)
             (-toDir (concat -destDir (string-remove-prefix -root -oneSrcDir))))
         (make-directory -toDir t)
         (if (version<= "24.2" emacs-version)
             (copy-directory -fromDir -toDir "KEEP-TIME" "PARENTS" "COPY-CONTENTS")
           (user-error "error75402: requires emacs version 24.3 or later." ))
         (princ (format "Copying from 「%s」 to 「%s」\n" -fromDir -toDir))))
     -sourceDirList)

    ;; copy the style sheets over, and icons dir
    (copy-file "~/web/xahlee_info/lbasic.css" -destDir "OK-IF-ALREADY-EXISTS")
    (copy-file "~/web/xahlee_info/lit.css" -destDir "OK-IF-ALREADY-EXISTS")
    (copy-file "~/web/xahlee_info/lmath.css" -destDir "OK-IF-ALREADY-EXISTS")
    (copy-directory "~/web/xahlee_info/ics/" (concat -destDir "ics/") "KEEP-TIME" "PARENTS" "COPY-CONTENTS")

;;     ;; 2016-07-09 modify css so that there's no big right margin for ads
;;     (let ((fpath (concat -destDir "lbasic.css" )))
;;       (with-temp-buffer
;;         (insert-file-contents fpath)
;;         (goto-char (point-max))
;;         (insert "
;; body { margin-right:1em; }
;; #aside-right-89129 {display:none;}
;; " )
;;         (write-region 1 (point-max) fpath)))

  ;     (xah-delete-xahtemp-files -destDir)
    (princ
     (shell-command (format "python3 /home/xah/git/xahscripts/make_download_copy/delete_temp_files.py3 %s"  -destDir)))

    ;; change local links to “http://” links. Delete the google javascript snippet, and other small fixes.
    (princ "Removing javascript etc in files…\n")
    (mapc
     (lambda (-oneSrcDir)
       (let ((-fileList
              (find-lisp-find-files
               (concat -destDir (string-remove-prefix -root -oneSrcDir)) "\\.html$")))
         (mapc
          (lambda (-f)
            (let ((-origPath (concat -root (substring -f (length -destDir)))))
              ;; (progn
              ;;   (princ "\n70556---------------\n")
              ;;   (princ -f)
              ;;   (princ "\n")
              ;;   (princ -origPath)
              ;;   (princ "\n")
              ;;   (princ -root))
              (xah-process-file-for-download -f -origPath -root)))
          -fileList)))
     -sourceDirList)

    (princ "Making download copy completed.\n")))


;; programing

;; (xah-make-downloadable-copy
;;  "~/web/"
;;  [
;;   "~/web/ergoemacs_org/"
;;   ]
;;  "~/web/xahlee_org/diklo/xx23/")

;; (xah-make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/js/" ]
;;  "~/web/xahlee_org/diklo/xxxx3/")

;; (xah-make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/js/" ]
;;  "~/web/xahlee_org/diklo/xah_dhtml_tutorial/")

;; (xah-make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/perl-python/" ]
;;  "~/web/xahlee_org/diklo/xah_perl-python_tutorial/")

;; ----------------------
;; math

;; (xah-make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/Wallpaper_dir/" ]
;;  "~/web/xahlee_org/diklo/wallpaper_groups/")

;; ----------------------
;; literature

;; (xah-make-downloadable-copy
;;  "~/web/wordyenglish_com/"
;;  [ "~/web/wordyenglish_com/words/" ]
;;  "~/web/xahlee_org/diklo/xxwords/")

;; (xah-make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/p/time_machine/" ]
;;  "~/web/xahlee_org/diklo/time_machine/")

;; (xah-make-downloadable-copy "~/web/xahlee_org/" [ "~/web/xahlee_org/flatland/" ]  "~/xx283/")

;; 2014-01-22
;; ;; need to remove nav bar
;; ;; need to include the JavaScript annotation script
;; (xah-make-downloadable-copy
;;  "~/web/wordyenglish_com/"
;;  [ "~/web/wordyenglish_com/titus/" ]
;;  "~/web/wordyenglish_com/diklo/xxtitus/")

;; "~/web/wordyenglish_com/titus/"

;; (xah-make-downloadable-copy
;;  "~/web/wordyenglish_com/"
;;  [
;;  "~/web/wordyenglish_com/monkey_king/" ]
;;  "~/web/xahlee_org/diklo/monkey_king/")

;; (xah-make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/p/arabian_nights/" ]
;;  "~/web/xahlee_org/diklo/arabian_nights/")

;; (xah-make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/p/um/" ]
;;  "~/web/xahlee_org/diklo/xy-unabomber/")

;; (xah-make-downloadable-copy
;;  "~/web/xahlee_info/"
;;  [ "~/web/xahlee_info/SpecialPlaneCurves_dir/" ]
;;  "~/web/xahlee_org/diklo/xx-plane_curves_aw/")

;; (xah-make-downloadable-copy
;;  "~/web/xahlee_info/"
;;  [ "~/web/xahlee_info/SpecialPlaneCurves_dir/_curves_robert_yates/" ]
;; "~/web/xahlee_org/diklo/xx_yates"
;; )

