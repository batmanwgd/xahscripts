;; -*- coding: utf-8 -*-
;; 2008-06-12, 2009-08-10, 2009-08-24, 2012-05-05

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

(load-file "/home/xah/git/xah_emacs_init/xah_emacs_xahsite_path_lisp_util.el")

(require 'xeu_elisp_util) ; substract-path
(require 'xfrp_find_replace_pairs)      ; replace-pairs-region etc
(require 'find-lisp)


;;;; functions

;; (xah-get-full-url "~/web/xahlee_org/emacs/emacs.html" "../Periodic_dosage_dir/skami_prosa.html" "~/web/xahlee_org/" "xahlee.org")

(defun xah-get-full-url (φ-file-path φ-linkpath φ-web-doc-root φ-host-name)
  "Returns a “http://” based URL of a given φ-linkpath, based on its φ-file-path, and {φ-web-doc-root, φ-host-name}.

φ-file-path is the full path to a html file.
φ-linkpath is a string that's relative path to φ-file-path. e.g. 「<a href=\"‹φ-linkpath›\">」.
φ-web-doc-root is the path to a ancestor dir of φ-file-path (i.e. it should be part of start of φ-file-path).

Returns a URL of the form “http://‹φ-host-name›/‹urlPath›” that points to the same file as φ-linkpath.

For example:
 (xah-get-full-url
 \"/Users/xah/web/xahlee_org/Periodic_dosage_dir/t2/mirrored.html\"
 \"../../p/demonic_males.html\"
 \"/Users/xah/web/xahlee_org/\"
 \"xahlee.org\"
 )
Returns
 「\"http://xahlee.org/xahlee_org/p/demonic_males.html\"」

Note that φ-web-doc-root may or may not end in a slash."
  (concat "http://" φ-host-name "/"
          (substring
           (expand-file-name (concat (file-name-directory φ-file-path) φ-linkpath))
           (length (file-name-as-directory (directory-file-name (expand-file-name φ-web-doc-root)))))))

(defun xah-drop-last-slash (φ-path)
  "Remove the last φ-path separated by “/”.
For example:
“/a/b/c/d” → “/a/b/c”
“/a/b/c/d/” → “/a/b/c/d”
“/” → “”
“//” → “/”
“” → “”"
  (if (string-match "\\(.*/\\)+" φ-path)
      (substring φ-path 0 (1- (match-end 0)))
    φ-path))

(defun xah-copy-dir-single-level (φ-sourcedir φ-destdir)
  "Copy all files from Φ-SOURCEDIR to Φ-DESTDIR.

The input dir should not end in a slash.
Example usage:
 (xah-copy-dir-single-level
 \"/Users/xah/web/p/um\"
 \"/Users/xah/web/diklo/xx\")

Note: no consideration is taken about links, alias, or file perms."
  (mapc
   (lambda (ξx)
     (let ()
       (when (and (not (string-equal ξx ".")) (not (string-equal ξx "..")))
         (copy-file
          (concat φ-sourcedir "/" ξx) φ-destdir) ) ) )
   (directory-files φ-sourcedir) ) )

 (defun xah-delete-xahtemp-files (φ-dir-path)
   "Delete some files and dirs in dir φ-dir-path.

File/Dir deleted are file/dir names that:

• start with xx
• ends with ~
• #…#
• .DS_Store
  etc."
   (progn
     ;; remove emacs backup files, temp files, mac os x files, etc.
     (princ "Removing temp files…\n")
     (delete-files-by-regex φ-dir-path "\\`\\.htaccess\\'")
     (delete-files-by-regex φ-dir-path "\\`#.?+#\\'")
     (delete-files-by-regex φ-dir-path "\\`xx")
     (delete-files-by-regex φ-dir-path "\\`\\.DS_Store\\'")
     (shell-command "find . -depth -type d -name 'xx*' -exec rm {} ';'")  ; TODO: stop calling shell command. use elisp instead
     ))

(defun xah-process-file-for-download (φ-file-path φ-original-file-path webRoot)
  "Modify the HTML file at φ-file-path, to make it ready for download bundle.

This function change local links to “http://” links, Delete the google javascript snippet, and other small changes, so that the file is nicer to be viewed off-line at some computer without the entire xahlee.org's web dir structure.

The google javascript is the Google Analytics webbug that tracks web stat to xahlee.org.

φ-file-path is the full path to the html file that will be processed.
φ-original-file-path is full path to the “same” file in the original web structure.
φ-original-file-path is used to construct new relative links."
  (let ( bds p1 p2 hrefValue default-directory
             (case-fold-search nil)
             )

    (with-temp-file φ-file-path
      (insert-file-contents φ-file-path)
      (goto-char 1)

      (xahsite-remove-ads (point-min) (point-max))

      ;; go thru each link, if the link is local, then check if the file exist. if not, replace the link with proper http://xahlee.org/ url
      (goto-char 1)
      (while (search-forward-regexp "<a href=\"" nil t)

        (forward-char 1)
        (setq bds (bounds-of-thing-at-point 'filename))
        (setq p1 (car bds))
        (setq p2 (cdr bds))
        (setq hrefValue (buffer-substring-no-properties p1 p2))

        (when (xahsite-local-link-p hrefValue)
          (setq default-directory (file-name-directory φ-file-path) )
          (when (not (file-exists-p (elt (split-uri-hashmark hrefValue) 0)))
            (delete-region p1 p2)
            (insert
             ;; (xahsite-filepath-to-href-value (xahsite-href-value-to-filepath hrefValue φ-original-file-path) φ-original-file-path)
             (xah-get-full-url φ-original-file-path hrefValue webRoot (xahsite-get-domain-of-local-file-path φ-original-file-path))
)
)))

      (goto-char 1)
      (while (search-forward-regexp "<img src[[:blank:]]*=[[:blank:]]*" nil t)
        (forward-char 1)
        (setq bds (bounds-of-thing-at-point 'filename))
        (setq p1 (car bds))
        (setq p2 (cdr bds))
        (setq hrefValue (buffer-substring-no-properties p1 p2))

        (when (xahsite-local-link-p hrefValue)
          (setq default-directory (file-name-directory φ-file-path) )
          (when (not (file-exists-p hrefValue))
            (delete-region p1 p2)
            (insert (xah-get-full-url φ-original-file-path hrefValue webRoot (xahsite-get-domain-of-local-file-path φ-original-file-path)))
            )))
      ) ))

(defun xah-make-downloadable-copy (φ-web-doc-root φ-source-dir-list φ-dest-dir )
  "Make a copy of a set of subdirs of Xah Site, for download.

All paths must be full paths.
All dir paths should end in slash.

• φ-web-doc-root is the website doc root dir. e.g. “/Users/xah/web/xahlee_org/”

• φ-source-dir-list is a list/sequence of dir paths to be copied for download. e.g.
 [\"/Users/xah/web/xahlee_org/emacs/\" \"/Users/xah/web/xahlee_org/comp/\" ]
Each path should be a subdir of φ-web-doc-root.

• φ-dest-dir is the destination dir. e.g.
 “/Users/xah/web/xahlee_org/diklo/emacs_tutorial_2012-05-05”
if exist, it'll be overridden.
"
  (let (
        ;; add ending slash, to be safe
        (ξroot (file-name-as-directory (expand-file-name φ-web-doc-root)))
        (ξsourceDirList (mapcar (lambda (ξx) (file-name-as-directory (expand-file-name ξx))) φ-source-dir-list) ) 
        (ξdestDir (file-name-as-directory (expand-file-name φ-dest-dir)))
        )

         (princ "ξsourceDirList")
         (princ ξsourceDirList)

    ;; copy to destination
    (mapc
     (lambda (ξoneSrcDir)
       (let ((fromDir ξoneSrcDir)
             (toDir (concat ξdestDir (substract-path ξoneSrcDir ξroot)) ))
         (make-directory toDir t)

         (cond
          ((< emacs-major-version 24) (copy-directory fromDir toDir))
          ((= emacs-major-version 24)
           (if (>= emacs-minor-version 3)
               (progn (copy-directory fromDir toDir "KEEP-TIME" "PARENTS" "COPY-CONTENTS")
                      (message "coccccccy→ %s %s" fromDir toDir)
                      )
             (if (file-exists-p toDir)
                 (copy-directory fromDir (concat toDir "/../"))
               (copy-directory fromDir toDir) )
             )
           )
          )
;         (if (>= emacs-major-version 24)
;             (if (file-exists-p toDir)
;                 (copy-directory fromDir (concat toDir "/../"))
;               (copy-directory fromDir toDir) )
;           (copy-directory fromDir toDir) )
         (princ (format "Copying from 「%s」 to 「%s」\n" fromDir  toDir))
         ))
     ξsourceDirList)

    ;; copy the style sheets over, and icons dir
    (copy-file "~/web/xahlee_org/lbasic.css" ξdestDir "OK-IF-ALREADY-EXISTS")
    (copy-file "~/web/xahlee_org/lit.css" ξdestDir "OK-IF-ALREADY-EXISTS")
    (copy-directory "~/web/xahlee_org/ics/" (concat ξdestDir "ics/") "KEEP-TIME" "PARENTS" "COPY-CONTENTS")

;     (xah-delete-xahtemp-files ξdestDir)
    (princ
     (shell-command (format "python3 ./delete_temp_files.py3 %s"  ξdestDir) )
 )

    ;; change local links to “http://” links. Delete the google javascript snippet, and other small fixes.
    (princ "Removing javascript etc in files…\n")
    (mapc
     (lambda (ξoneSrcDir)
       (let ((ξfileList (find-lisp-find-files (concat ξdestDir (substract-path ξoneSrcDir ξroot) ) "\\.html$")))

         (mapc
          (lambda (ξf)

            (let ((ξorigPath (concat ξroot (substring ξf (length ξdestDir)))))
              (princ "---------------\n")
              (princ ξf)
              (princ "\n")
              (princ ξorigPath)
              (princ "\n")
              (princ ξroot)

              (xah-process-file-for-download ξf ξorigPath ξroot)
              )
            )
          ξfileList)
         )
       )
     ξsourceDirList)

    (princ "Making download copy completed.\n")
    )
  )


;; programing

 (xah-make-downloadable-copy
  "~/web/ergoemacs_org/"
  [
   "~/web/ergoemacs_org/"
;   "~/web/ergoemacs_org/emacs/"
;   "~/web/ergoemacs_org/emacs_manual/"
;   "~/web/ergoemacs_org/misc/"
;   "~/web/ergoemacs_org/i/"
   ]
  "~/web/xahlee_org/diklo/xx_xah_emacs_tutorial/")

;; ;; 2014-05-19 doesn't work well
;;  (xah-make-downloadable-copy
;;   "~/web/xahlee_info/"
;;   [
;; "~/web/xahlee_info/js/"
;; "~/web/xahlee_info/javascript_ecma-262_5.1_2011/"
;; "~/web/xahlee_info/jquery_doc/"
;; "~/web/xahlee_info/node_api/"
;;    ]
;;   "~/web/xahlee_org/diklo/xx_xah_js_tutorial/")

 ;; (xah-make-downloadable-copy
 ;;  "~/web/xahlee_info/"
 ;;  [
 ;;   "~/web/xahlee_info/"
 ;;   ]
 ;;  "~/web/xahlee_org/diklo/xahlee_info/")

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
;;  "~/web/xahlee_info/"
;;  [ "~/web/xahlee_info/java-a-day/" ]
;;  "~/web/xahlee_org/diklo/xx_xah_java_tutorial/")

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

