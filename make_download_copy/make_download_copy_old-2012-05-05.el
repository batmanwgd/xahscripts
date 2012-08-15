;; -*- coding: utf-8 -*-
; 2008-06-12, 2009-08-10, 2009-08-24

;; make a downloadable copy of my website
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

;; (require 'xfrp_find_replace_pairs)
(load-file "~/ErgoEmacs_Source/ergoemacs/packages/xfrp_find_replace_pairs.elc")
(require 'find-lisp)


;; § ----------------------------------------
;;;; functions

(defun delete-subdirs-by-regex (ξdir regex-pattern)
  "Delete sub-directories in ΞDIR whose path matches REGEX-PATTERN."
  (mapc
   (lambda (ξx) (if (and (file-directory-p ξx) (file-exists-p ξx))
                    (delete-directory ξx t)))
   (find-lisp-find-files ξdir regex-pattern)) )

(defun delete-files-by-regex (ξdir regex-pattern)
  "Delete all files in a ΞDIR whose path matches a REGEX-PATTERN.
Example:
 (delete-files-by-regex \"~/web\" \"~$\")
This deletes all files ending in “~”."
  (mapc
   (lambda (ξx) (if (and (file-regular-p ξx) (file-exists-p ξx))
                    (delete-file ξx)) )
   (find-lisp-find-files ξdir regex-pattern)) )

;; (compute-url-from-relative-link "c:/Users/h3/web/xahlee_org/emacs/emacs.html" "../Periodic_dosage_dir/skami_prosa.html" "c:/Users/h3/web/xahlee_org/" "xahlee.org")

(defun compute-url-from-relative-link (fPath linkPath webDocRoot hostName)
  "Returns a “http://” based URL of a given linkPath,
based on its fPath, webDocRoot, hostName.

fPath is the full path to a html file.
linkPath is a string that's relative path to fPath.
linkPath should be from a 「<a href=\"…\">」 tag at fPath.
webDocRoot is the path to a ancestor dir of fPath (i.e. it should be part of start of fPath).

Returns a URL of the form “http://‹hostName›/‹urlPath›”
that points to the same file as linkPath.

For example:
 (compute-url-from-relative-link
 \"/Users/xah/web/xahlee_org/Periodic_dosage_dir/t2/mirrored.html\"
 \"../../p/demonic_males.html\"
 \"/Users/xah/web/xahlee_org/\"
 \"xahlee.org\"
 )
Returns
 「\"http://xahlee.org/xahlee_org/p/demonic_males.html\"」

Note that webDocRoot may or may not end in a slash."
  (concat "http://" hostName "/"
          (substring
           (expand-file-name (concat (file-name-directory fPath) linkPath))
           (length (file-name-as-directory (directory-file-name (expand-file-name webDocRoot)))))))

(defun clean-file (fPath originalFilePath)
  "Modify the HTML file at fPath, to make it ready for download bundle.

This function change local links to “http://” links,
Delete the google javascript snippet, and other small changes,
so that the file is nicer to be viewed off-line at some computer
without the entire xahlee.org's web dir structure.

The google javascript is the Google Analytics webbug that tracks
 web stat to xahlee.org.

fPath is the full path to the html file that will be processed.
originalFilePath is full path to the “same” file in the original web structure.
originalFilePath is used to construct new relative links."
  (let ( bds p1 p2 linkPath linkPathSansJumper default-directory)

(with-temp-file fPath
    (insert-file-contents fPath)
(replace-pairs-region (point-min) (point-max)

[

["<script>var _gaq = _gaq || []; _gaq.push(['_setAccount', 'UA-10884311-2']); _gaq.push(['_trackPageview']); (function() { var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true; ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s); })();</script>" ""]

["<div class=\"¤\"><a href=\"http://ode-math.com/\" rel=\"nofollow\">Differential Equations, Mechanics, and Computation</a></div>" ""]

["<div class=\"chtk\"><script>ch_client=\"polyglut\";ch_width=550;ch_height=90;ch_type=\"mpu\";ch_sid=\"Chitika Default\";ch_backfill=1;ch_color_site_link=\"#00C\";ch_color_title=\"#00C\";ch_color_border=\"#FFF\";ch_color_text=\"#000\";ch_color_bg=\"#FFF\";</script><script src=\"http://scripts.chitika.net/eminimalls/amm.js\"></script></div>" ""]

["<div class=\"¤1n1\"><a href=\"http://www.1and1.com/?k_id=10914806\" rel=\"nofollow\"><img src=\"http://banner.1and1.com/xml/banner?size=5%26%number=1\" width=\"140\" height=\"28\" alt=\"Banner\"></a></div>" ""]

[
"<script charset=\"utf-8\" src=\"http://ws.amazon.com/widgets/q?rt=tf_sw&amp;ServiceVersion=20070822&amp;MarketPlace=US&amp;ID=V20070822/US/xahhome-20/8002/beeeb846-55b8-41fc-9165-bf25f3cbe2f0\"></script>"
""]

["<div class=\"¤xd\"><a href=\"../../../../ads.html\">Advertise Here</a></div>" ""]
["<div class=\"¤xd\"><a href=\"../../../ads.html\">Advertise Here</a></div>" ""]
["<div class=\"¤xd\"><a href=\"../../ads.html\">Advertise Here</a></div>" ""]
["<div class=\"¤xd\"><a href=\"../ads.html\">Advertise Here</a></div>" ""]
["<div class=\"¤xd\"><a href=\"ads.html\">Advertise Here</a></div>" ""]

["<script><!--
amazon_ad_tag = \"xahh-20\"; amazon_ad_width = \"728\"; amazon_ad_height = \"90\"; amazon_ad_logo = \"hide\"; amazon_color_border = \"7E0202\";//--></script>
<script src=\"http://www.assoc-amazon.com/s/ads.js\"></script>" 
""]

[
"<a rel=\"author\" href=\"Periodic_dosage_dir/t1/presences.html\">Xah Lee</a>"
"Xah Lee"
]

[
"<a rel=\"author\" href=\"../Periodic_dosage_dir/t1/presences.html\">Xah Lee</a>"
"Xah Lee"
]

[
"<a rel=\"author\" href=\"../../Periodic_dosage_dir/t1/presences.html\">Xah Lee</a>"
"Xah Lee"
]

["<div id=\"disqus_thread\"></div><script>(function(){var dsq=document.createElement('script');dsq.type='text/javascript';dsq.async=true;dsq.src='http://xahlee.disqus.com/embed.js';(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);})();</script><a href=\"http://disqus.com\" class=\"dsq-brlink\">blog comments powered by <span class=\"logo-disqus\">Disqus</span></a>" ""]

["<iframe style=\"width:100%;border:none\" src=\"../../../../footer.html\"></iframe>" ""]
["<iframe style=\"width:100%;border:none\" src=\"../../../footer.html\"></iframe>" ""]
["<iframe style=\"width:100%;border:none\" src=\"../../footer.html\"></iframe>" ""]
["<iframe style=\"width:100%;border:none\" src=\"../footer.html\"></iframe>" ""]
["<iframe style=\"width:100%;border:none\" src=\"footer.html\"></iframe>" ""]
["<iframe style=\"width:100%;border:none\" src=\"http://xahlee.org/footer.html\"></iframe>" ""]

["<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js\"></script>" ""]

["<script src=\"../../../../xlomain.js\"></script>" ""]
["<script src=\"../../../xlomain.js\"></script>" ""]
["<script src=\"../../xlomain.js\"></script>" ""]
["<script src=\"../xlomain.js\"></script>" ""]
["<script src=\"xlomain.js\"></script>" ""]

]

)

(replace-regexp-pairs-region (point-min) (point-max)
[
["\n\n+" "\n\n"]
["<div class=\"βds\">\n*</div>" ""]
]
  t t)

    ;; go thru each link, if the link is local, then check if the file exist. if not, replace the link with proper http://xahlee.org/ url
    (goto-char 1)
    (while (search-forward-regexp "<[[:blank:]]*a[[:blank:]]+href[[:blank:]]*=[[:blank:]]*" nil t)

      (forward-char 1)
      (setq bds (bounds-of-thing-at-point 'filename))
      (setq p1 (car bds))
      (setq p2 (cdr bds))
      (setq linkPath (buffer-substring-no-properties p1 p2))

      (when (not (string-match "^http://" linkPath))
        ;; get rid of trailing jumper, e.g. “Abstract-Display.html#top”
        (setq linkPathSansJumper (replace-regexp-in-string "^\\([^#]+\\)#.+" "\\1" linkPath t))

        (setq default-directory (file-name-directory fPath) )
        (when (not (file-exists-p linkPathSansJumper))
          (delete-region p1 p2)
          (insert (compute-url-from-relative-link originalFilePath linkPath ξwebroot "xahlee.org"))
          )))

    (goto-char 1)
(while (search-forward-regexp "<[[:blank:]]*img[[:blank:]]+src[[:blank:]]*=[[:blank:]]*" nil t)

  (forward-char 1)
  (setq bds (bounds-of-thing-at-point 'filename))
  (setq p1 (car bds))
  (setq p2 (cdr bds))
  (setq linkPath (buffer-substring-no-properties p1 p2))

  (when (not (string-match "^http://" linkPath))

    (setq default-directory (file-name-directory fPath) )
    (when (not (file-exists-p linkPath))
      (delete-region p1 p2)
      (insert (compute-url-from-relative-link originalFilePath linkPath ξwebroot "xahlee.org"))
      )))
) ))

(defun drop-last-slashed-substring (path)
  "drop the last path separated by “/”.
For example:
“/a/b/c/d” → “/a/b/c”
“/a/b/c/d/” → “/a/b/c/d”
“/” → “”
“//” → “/”
“” → “”"
  (if (string-match "\\(.*/\\)+" path)
      (substring path 0 (1- (match-end 0)))
    path))

(defun copy-dir-single-level (sourcedir destdir)
  "Copy all files from SOURCEDIR to DESTDIR.

The input dir should not end in a slash.
Example usage:
 (copy-dir-single-level
 \"/Users/xah/web/p/um\"
 \"/Users/xah/web/diklo/xx\")

Note: no consideration is taken about links, alias, or file perms."
  (mapc
   (lambda (ξx)
     (let ()
       (when (and (not (string-equal ξx ".")) (not (string-equal ξx "..")))
         (copy-file
          (concat sourcedir "/" ξx) destdir) ) ) )
   (directory-files sourcedir) ) )



;; § ----------------------------------------
;; main

;; Make a copy of web dir of XahLee.org for download.

;; This function depends on unspecified structure of XahLee.org.
;;  (that is, prob not useful to you.)

;; ξwebroot is the website doc root dir. (must end in slash) e.g. “/Users/xah/web/xahlee_org/”
(setq ξwebroot "c:/Users/h3/web/xahlee_org/")
(setq ξwebroot "~/web/xahlee_org/")

;; ξsourceDirsList is a list of dir paths relative to ξwebroot, to be copied for download. Must not end in slash.  e.g. (list \"p/time_machine\")
(setq ξsourceDirsList (list "SpecialPlaneCurves_dir/ggb"))
(setq ξsourceDirsList (list "PageTwo_dir/Vocabulary_dir"))
(setq ξsourceDirsList (list "SpecialPlaneCurves_dir/_curves_robert_yates/" ))
(setq ξsourceDirsList (list "p/monkey_king" ))
(setq ξsourceDirsList (list "emacs"))
(setq ξsourceDirsList (list "emacs"  "emacs_manual"))

;; ξdestDirRelativePath is the destination dir of the download. It must be a relative path to ξwebroot. e.g. 「"diklo"」
(setq ξdestDirRelativePath "diklo")

;; ξzipCoreName is the downloable archive name, without the suffix.  e.g. “time_machine”
(setq ξzipCoreName "curves_geogebra_2012-02-06_jls")
(setq ξzipCoreName "xah_vocabulary_2012-03-23")
(setq ξzipCoreName "curves_robert_yates")
(setq ξzipCoreName "monkey_king")
(setq ξzipCoreName "xah_emacs_tutorial")

;; use-gzip-p means whether to use gzip, else zip for the final archive.  If non-nil, use gzip.
(setq ξuse-gzip-p nil)

(progn
  (setq ξwebroot (file-name-as-directory (expand-file-name ξwebroot)))
  (setq ζdestRoot (file-name-as-directory (concat ξwebroot ξdestDirRelativePath)) )
  (setq ζdestDir (file-name-as-directory (concat ζdestRoot ξzipCoreName)))

  ;; copy to destination
  (mapc
   (lambda (ξx)
     (let (fromDir toDir)
       (setq fromDir (concat ξwebroot ξx))
       (setq toDir
             (concat ξwebroot ξdestDirRelativePath "/" ξzipCoreName "/" ξx) )
       (make-directory toDir t)
       (if (>= emacs-major-version 24)
           (if (file-exists-p toDir)
               (copy-directory fromDir (concat toDir "/../"))
             (copy-directory fromDir toDir) )
         (copy-directory fromDir toDir) )
       (princ (concat "Copying " fromDir " " toDir " …\n"))
       ))
   ξsourceDirsList)

  ;; copy the style sheets over, and icons dir
  (copy-file (concat ξwebroot "lang.css") ζdestDir)
  (copy-file (concat ξwebroot "lbasic.css") ζdestDir)
  (copy-file (concat ξwebroot "lit.css") ζdestDir)
  (copy-directory (concat ξwebroot "ics/") (concat ζdestDir "ics/"))

  ;; remove emacs backup files, temp files, mac os x files, etc.
  (princ "Removing temp files…\n")
  (delete-subdirs-by-regex ζdestDir "^xx")
  (delete-files-by-regex ζdestDir "~$")
  (delete-files-by-regex ζdestDir "^#.+#$")
  (delete-files-by-regex ζdestDir "^xx")
  (delete-files-by-regex ζdestDir "^\\.DS_Store$")

  ;; change local links to “http://” links. Delete the google javascript snippet, and other small fixes.
  (princ "Removing javascript etc in files…\n")
  (mapc (lambda (ξx)
          (mapc
           (lambda (ξf) (clean-file ξf (concat ξwebroot (substring ξf (length ζdestDir)))))
           (find-lisp-find-files (concat ζdestDir ξx) "\\.html$")))
        ξsourceDirsList)

  ;; ;; zip the dir
  ;; (princ "Zipping dir…\n")
  ;; (let (ff)
  ;;   (setq ff (concat ξwebroot ξdestDirRelativePath "/" ξzipCoreName ".zip"))
  ;;   (when (file-exists-p ff) (delete-file ff))
  ;;   (setq ff (concat ξwebroot ξdestDirRelativePath "/" ξzipCoreName ".tar.gz"))
  ;;   (when (file-exists-p ff) (delete-file ff)))
  ;; (setq default-directory (concat ξwebroot ξdestDirRelativePath "/"))
  ;; (when (equal
  ;;        0
  ;;        (if ξuse-gzip-p
  ;;            (shell-command (concat "tar cfz " ξzipCoreName ".tar.gz " ξzipCoreName))
  ;;          (shell-command (concat "zip -r " ξzipCoreName ".zip " ξzipCoreName))))
  ;;   (delete-directory ζdestDir t))

  (dired (concat ξwebroot "/" ξdestDirRelativePath))

  (princ "Making download copy completed.\n")
)


;; § ----------------------------------------
;; programing

;; (make-downloadable-copy
;; "/Users/h3/web/xahlee_org/"
;; (list "emacs" "emacs_manual")
;;  "diklo" "xah_emacs_tutorial")

;; (make-downloadable-copy
;; "/Users/h3/web/xahlee_org/"
;; (list "emacs")
;;  "diklo" "xah_emacs_tutorial")

;; (make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "js")
;;  "diklo" "xah_dhtml_tutorial")

;; (make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "elisp")
;;  "diklo" "elisp_manual")

;; (make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "java-a-day")
;;  "diklo" "xah_java_tutorial")

;; (make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "perl-python")
;;  "diklo" "xah_perl-python_tutorial")

;; ;; ----------------------
;; ;; math

;; (make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "Wallpaper_dir")
;;  "diklo" "wallpaper_groups")

;; ;; ----------------------
;; ;; literature


;; (make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "PageTwo_dir/Vocabulary_dir")
;;  "diklo" "vocabulary")

;; (make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "p/time_machine")
;;  "diklo" "time_machine")

;; (make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "flatland")
;;  "diklo" "flatland")

;; (make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "p/titus")
;;  "diklo" "titus")

;; (make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "p/monkey_king")
;;  "diklo" "monkey_king")

;; (make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "p/arabian_nights")
;;  "diklo" "arabian_nights")

;; (make-downloadable-copy
;;  "C:/Users/h3/web/xahlee_org/"
;;  (list "p/um")
;;  "diklo" "unabomber_manifesto")

;; ;; (make-downloadable-copy
;; ;;  "C:/Users/h3/web/xahlee_org/"
;; ;; (list "p/mopi") "diklo" "mopi")

;; (make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "SpecialPlaneCurves_dir")
;;  "diklo" "plane_curves_aw")
