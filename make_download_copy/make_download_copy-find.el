;; -*- coding: utf-8; lexical-binding: t; -*-
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

(require 'xah-replace-pairs)


;; § ----------------------------------------
;;;; functions

(defun xah-delete-files-by-regex (dir regex-pattern)
  "Delete all files in a DIR matching a REGEX-PATTERN.
Example:
 (xah-delete-files-by-regex \"~/web\" \"~$\")
This deletes all files ending in “~”."
(require 'find-lisp)
(mapc
 (lambda (x) (delete-file x))
 (find-lisp-find-files dir regex-pattern)) )

;; (xah-get-full-url "c:/Users/h3/web/xahlee_org/emacs/emacs.html" "../Periodic_dosage_dir/skami_prosa.html" "c:/Users/h3/web/xahlee_org/" "xahlee.org")

(defun xah-get-full-url (fPath linkPath webDocRoot hostName)
  "Returns a “http://” based URL of a given linkPath,
based on its fPath, webDocRoot, hostName.

fPath is the full path to a html file.
linkPath is a string that's relative path to another file,
from a “<a href=\"...\"> tag.”
webDocRoot is the full path to a parent dir of fPath.
Returns a url of the form “http://hostName/‹urlPath›”
that points to the same file as linkPath.

For example:
 (xah-get-full-url
\"/Users/xah/web/xahlee_org/Periodic_dosage_dir/t2/mirrored.html\"
\"../../p/demonic_males.html\"
\"/Users/xah/web/xahlee_org/\"
\"xahlee.org\"
)
Returns
“\"http://xahlee.org/xahlee_org/p/demonic_males.html\"”

Note that webDocRoot may or may not end in a slash."
  (concat "http://" hostName "/"
          (substring
           (file-truename (concat (file-name-directory fPath) linkPath))
           (length (file-name-as-directory (directory-file-name webDocRoot))))))

(defun clean-file (fPath originalFilePath)
  "Modify the HTML file at fPath, to make it ready for download bundle.

This function change local links to “http://” links,
Delete the google javascript snippet, and other small changes,
so that the file is nicer to be viewed offline at some computer
without the entire xahlee.org's web dir structure.

The google javascript is the Google Analytics webbug that tracks
 web stat to xahlee.org.

fPath is the full path to the html file that will be processed.
originalFilePath is full path to the “same” file in the original web structure.
originalFilePath is used to construct new relative links."
  (let (myBuffer bds p1 p2 linkPath linkPathSansJumper)

    (setq myBuffer (find-file fPath))

(replace-pairs-region (point-min) (point-max)

[
;; ["<iframe src=\"http://xahlee.org/header.html\" width=\"100%\" height=\"60\" align=\"top\" frameborder=\"0\"></iframe>" ""]

["<script>var _gaq = _gaq || []; _gaq.push(['_setAccount', 'UA-10884311-2']); _gaq.push(['_trackPageview']); (function() { var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true; ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s); })();</script>" ""]

["<div class=\"hdζ\"><span class=\"σ\">∑</span> <a href=\"http://xahlee.org/index.html\">Home</a> ◇ <a href=\"http://xahlee.org/Periodic_dosage_dir/cmaci_girzu.html\">Math</a> ◇ <a href=\"http://xahlee.org/Periodic_dosage_dir/skami_prosa.html\">Computing</a> ◇ <a href=\"http://xahlee.org/arts/index.html\">Arts</a> ◇ <a href=\"http://xahlee.org/PageTwo_dir/Vocabulary_dir/vocabulary.html\">Words</a> ◇ <a href=\"http://xahlee.org/Periodic_dosage_dir/t2/mirrored.html\">Literature</a> ◇ <a href=\"http://xahlee.org/music/index.html\">Music</a> ◆ <a href=\"http://twitter.com/xah_lee\" target=\"_top\"><img src=\"http://twitter.com/favicon.ico\" alt=\"twitter\"></a> <a href=\"http://www.facebook.com/xahlee\" target=\"_top\"><img src=\"http://xahlee.org/ics/fb3.png\" alt=\"facebook\"></a> <a href=\"http://gplus.to/xah\" target=\"_top\"><img src=\"http://xahlee.org/ics/gp.png\" alt=\"g+\"></a> <a href=\"http://xahlee.blogspot.com/feeds/posts/default\" target=\"_top\"><img src=\"http://xahlee.org/ics/wf.png\" alt=\"webfeed\"></a></div>" ""]

["<div class=\"¤\"><a href=\"http://ode-math.com/\" rel=\"nofollow\">Differential Equations, Mechanics, and Computation</a></div>" ""]

["<div class=\"chtk\"><script>ch_client=\"polyglut\";ch_width=550;ch_height=90;ch_type=\"mpu\";ch_sid=\"Chitika Default\";ch_backfill=1;ch_color_site_link=\"#00C\";ch_color_title=\"#00C\";ch_color_border=\"#FFF\";ch_color_text=\"#000\";ch_color_bg=\"#FFF\";</script><script src=\"http://scripts.chitika.net/eminimalls/amm.js\"></script></div>" ""]

["<script charset=\"utf-8\" src=\"http://ws.amazon.com/widgets/q?rt=tf_sw&ServiceVersion=20070822&MarketPlace=US&ID=V20070822/US/xahhome-20/8002/2aa120d1-c3eb-48eb-99d2-da30d030258e\"></script>" ""]

["<div class=\"¤xd\"><a href=\"http://xahlee.org/ads.html\">Advertise Here</a></div>" ""]

["<div class=\"¤1n1\"><a href=\"http://www.1and1.com/?k_id=10914806\" rel=\"nofollow\"><img src=\"http://banner.1and1.com/xml/banner?size=5%26%number=1\" width=\"140\" height=\"28\" alt=\"Banner\"></a></div>" ""]

["<script><!--
amazon_ad_tag = \"xahh-20\"; amazon_ad_width = \"728\"; amazon_ad_height = \"90\"; amazon_ad_logo = \"hide\"; amazon_color_border = \"7E0202\";//--></script>
<script src=\"http://www.assoc-amazon.com/s/ads.js\"></script>" ""]

["<div id=\"disqus_thread\"></div><script>(function(){var dsq=document.createElement('script');dsq.type='text/javascript';dsq.async=true;dsq.src='http://xahlee.disqus.com/embed.js';(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);})();</script><a href=\"http://disqus.com\" class=\"dsq-brlink\">blog comments powered by <span class=\"logo-disqus\">Disqus</span></a>" ""]

["<script src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js\"></script>" ""]

["<iframe src=\"http://xahlee.org/footer.html\" width=\"100%\" frameborder=\"0\"></iframe>" ""]

;; <div class="blgcmt"><a href="http://xahlee.blogspot.com/2010/07/gnu-emacs-developement-inefficiency.html">✍</a></div>

["<script src=\"http://xahlee.org/xlomain.js\"></script>" ""]
]

)

    ;; go thru each link, if the link is local, then check if the file exist. if not, replace the link with proper http://xahlee.org/ url
    (goto-char 1) ; in case buffer already open
    (while (search-forward-regexp "<[[:blank:]]*a[[:blank:]]+href[[:blank:]]*=[[:blank:]]*" nil t)
      (forward-char 1)
      (setq bds (bounds-of-thing-at-point 'filename))
      (setq p1 (car bds))
      (setq p2 (cdr bds))
      (setq linkPath (buffer-substring-no-properties p1 p2))

      (when (not (string-match "^http://" linkPath))

        ;; get rid of trailing jumper, e.g. “Abstract-Display.html#top”
        (setq linkPathSansJumper (replace-regexp-in-string "^\\([^#]+\\)#.+" "\\1" linkPath t))

        (when (not (file-exists-p linkPathSansJumper))
          (delete-region p1 p2)
          (let (newLinkPath)
            (setq newLinkPath (xah-get-full-url originalFilePath linkPath ξwebroot "xahlee.org"))
            (insert newLinkPath))
          (search-forward "</a>")
          (backward-char 4))))
    (save-buffer)
    (kill-buffer myBuffer)))

(defun xah-drop-last-slash (path)
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

(defun xah-copy-dir-single-level (sourcedir destdir)
  "Copy all files from SOURCEDIR to DESTDIR.

The input dir should not end in a slash.
Example usage:
 (xah-copy-dir-single-level
 \"/Users/xah/web/p/um\"
 \"/Users/xah/web/diklo/xx\")

Note: no consideration is taken about links, alias, or file perms."
  (mapc 
   (lambda (x)
     (let ()
       (when (and (not (string-equal x ".")) (not (string-equal x "..")))
         (copy-file
          (concat sourcedir "/" x) destdir) ) ) )
   (directory-files sourcedir) ) )



;; § ----------------------------------------
;; main

;; Make a copy of web dir of XahLee.org for download.

;; This function depends on unspecified structure of XahLee.org.
;;  (that is, prob not useful to you.)

;; ξwebroot is the website doc root dir. (must end in slash) e.g. “/Users/xah/web/xahlee_org/”
(setq ξwebroot "~/web/xahlee_org/")

;; ξsourceDirsList is a list of dir paths relative to ξwebroot, to be copied for download. Must not end in slash.  e.g. (list \"p/time_machine\")
(setq ξsourceDirsList (list "emacs" "emacs_manual"))

;; ξdestDirRelativePath is the destination dir of the download. It must be a relative path to ξwebroot. e.g. “diklo”
(setq ξdestDirRelativePath "diklo")

;; ξzipCoreName is the downloable archive name, without the suffix.  e.g. “time_machine”
(setq ξzipCoreName "xah_emacs_tutorial")

;; use-gzip-p means whether to use gzip, else zip for the final archive.  If non-nil, use gzip.
(setq ξuse-gzip-p nil)

(setq make-backup-files nil)
(font-lock-mode 0)
(recentf-mode 0)

(with-output-to-temp-buffer "*xah zip download dir output*"

  (setq ζdestRoot (concat ξwebroot ξdestDirRelativePath "/"))
  (setq ζdestDir (concat ζdestRoot ξzipCoreName "/"))

  ;; copy to destination
  ;; (mapc
  ;;  (lambda (x)
  ;;    (let (fromDir toDir)
  ;;      (setq fromDir (concat ξwebroot x))
  ;;      (setq toDir
  ;;            (xah-drop-last-slash (concat ξwebroot ξdestDirRelativePath "/" ξzipCoreName "/" x)) )
  ;;      (make-directory toDir t)
  ;;      (princ (concat "copying " fromDir " " toDir "\n"))
  ;;      (shell-command (concat "cp -R " fromDir " " toDir))
  ;;      ))
  ;;  ξsourceDirsList)

  (mapc
   (lambda (x)
     (let (fromDir toDir)
       (setq fromDir (concat ξwebroot x))
       (setq toDir
             (concat ξwebroot ξdestDirRelativePath "/" ξzipCoreName "/" x) )
       (make-directory toDir t)
       (copy-directory fromDir toDir)
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
  (xah-delete-files-by-regex ζdestDir "~$")
  (xah-delete-files-by-regex ζdestDir "^#.+#$")
  (xah-delete-files-by-regex ζdestDir "^xx")
  (xah-delete-files-by-regex ζdestDir "^\\.DS_Store$")

  (shell-command (concat "find " ζdestDir " -type f -empty -exec rm {} ';'"))
  (shell-command (concat "find " ζdestDir " -type d -empty -exec rmdir {} ';'"))
  (shell-command (concat "find " ζdestDir " -type d -name \"xx*\" -exec rm -R {} ';'"))

  ;; change local links to “http://” links. Delete the google javascript snippet, and other small fixes.
  (princ "Removing javascript etc in files…\n")
  (require 'find-lisp)

  (mapc (lambda (x)
          (mapc
           (lambda (fPath) (clean-file fPath (concat ξwebroot (substring fPath (length ζdestDir)))))
           (find-lisp-find-files (concat ζdestDir "/" x) "\\.html$")))
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

  (princ "Making download copy completed.\n")
)

(font-lock-mode 1)
(recentf-mode 1)



;; § ----------------------------------------
;; programing

;; (xah-make-downloadable-copy
;; "/Users/h3/web/xahlee_org/"
;; (list "emacs" "emacs_manual")
;;  "diklo" "xah_emacs_tutorial")

;; (xah-make-downloadable-copy
;; "/Users/h3/web/xahlee_org/"
;; (list "emacs")
;;  "diklo" "xah_emacs_tutorial")

;; (xah-make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "js")
;;  "diklo" "xah_dhtml_tutorial")

;; (xah-make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "elisp")
;;  "diklo" "elisp_manual")

;; (xah-make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "java-a-day")
;;  "diklo" "xah_java_tutorial")

;; (xah-make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "perl-python")
;;  "diklo" "xah_perl-python_tutorial")

;; ;; ----------------------
;; ;; math

;; (xah-make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "Wallpaper_dir")
;;  "diklo" "wallpaper_groups")

;; ;; ----------------------
;; ;; literature


;; (xah-make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "PageTwo_dir/Vocabulary_dir")
;;  "diklo" "vocabulary")

;; (xah-make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "p/time_machine")
;;  "diklo" "time_machine")

;; (xah-make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "flatland")
;;  "diklo" "flatland")

;; (xah-make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "p/titus")
;;  "diklo" "titus")

;; (xah-make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "p/monkey_king")
;;  "diklo" "monkey_king")

;; (xah-make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "p/arabian_nights")
;;  "diklo" "arabian_nights")

;; (xah-make-downloadable-copy
;;  "C:/Users/h3/web/xahlee_org/"
;;  (list "p/um")
;;  "diklo" "unabomber_manifesto")

;; ;; (xah-make-downloadable-copy
;; ;;  "C:/Users/h3/web/xahlee_org/" 
;; ;; (list "p/mopi") "diklo" "mopi")

;; (xah-make-downloadable-copy
;; "C:/Users/h3/web/xahlee_org/"
;; (list "SpecialPlaneCurves_dir")
;;  "diklo" "plane_curves_aw")
