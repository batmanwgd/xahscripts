;; -*- coding: utf-8 -*-
;; 2008-06-12, 2009-08-10, 2009-08-24, 2012-05-05

;; make a downloadable copy of my website. See function “make-downloadable-copy”
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

(require 'xeu_elisp_util) ; substract-path
(require 'xfrp_find_replace_pairs)      ; replace-pairs-region etc
(require 'find-lisp)


;; § ----------------------------------------
;;;; functions

;; (compute-url-from-relative-link "c:/Users/h3/web/xahlee_org/emacs/emacs.html" "../Periodic_dosage_dir/skami_prosa.html" "c:/Users/h3/web/xahlee_org/" "xahlee.org")

(defun compute-url-from-relative-link (fPath linkPath webDocRoot hostName)
  "Returns a “http://” based URL of a given linkPath,
based on its fPath, webDocRoot, hostName.

fPath is the full path to a html file.
linkPath is a string that's relative path to fPath. e.g. 「<a href=\"‹linkPath›\">」.
webDocRoot is the path to a ancestor dir of fPath (i.e. it should be part of start of fPath).

Returns a URL of the form “http://‹hostName›/‹urlPath›” that points to the same file as linkPath.

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

(defun xx-delete-temp-files (mydir)
  "delete some temp files and dirs…
dir/files starting with xx
 ends with ~
 #…#
 .DS_Store
 etc."
  (progn
    ;; remove emacs backup files, temp files, mac os x files, etc.
    (princ "Removing temp files…\n")
    (delete-subdirs-by-regex mydir "\\`xx")

    (delete-files-by-regex mydir "\\`\.htaccess\\'")
    (delete-files-by-regex mydir "~\\'")
    (delete-files-by-regex mydir "\\`#.+#\\'")
    (delete-files-by-regex mydir "\\`xx")
    (delete-files-by-regex mydir "\\`\\.DS_Store\\'")
    ))

(defun remove-ads-scripts-in-file (fPath originalFilePath webRoot)
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
  (let ( bds p1 p2 hrefValue default-directory
             (case-fold-search nil)
)

    (with-temp-file fPath
      (insert-file-contents fPath)
(goto-char 1)

;; ;; delete Google Analytic tracker code
;; (search-forward "<script>var _gaq = _gaq " nil "NOERROR")
;; (setq p1 (line-beginning-position) )
;; (search-forward "</script>")
;; (setq p2 (point) )
;; (delete-region p1 p2 )
 
(replace-pairs-region  (point-min) (point-max)
[
["<script><!--
google_ad_client = \"pub-5125343095650532\";
/* 728x90, created 8/12/09 */
google_ad_slot = \"8521101965\";
google_ad_width = 728;
google_ad_height = 90;
//-->
</script>
<script type=\"text/javascript\"
src=\"http://pagead2.googlesyndication.com/pagead/show_ads.js\">
</script>" ""]

[
"<div class=\"βshare\">
<div id=\"fb-root\"></div><script>(function(d, s, id) { var js, fjs = d.getElementsByTagName(s)[0]; if (d.getElementById(id)) return; js = d.createElement(s); js.id = id; js.src = \"//connect.facebook.net/en_US/all.js#xfbml=1\"; fjs.parentNode.insertBefore(js, fjs); }(document, 'script', 'facebook-jssdk'));</script>
<a href=\"https://twitter.com/share\" class=\"twitter-share-button\" data-via=\"ergoemacs\">Tweet</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=\"//platform.twitter.com/widgets.js\";fjs.parentNode.insertBefore(js,fjs);}}(document,\"script\",\"twitter-wjs\");</script>
<div class=\"g-plusone\" data-annotation=\"inline\" data-width=\"120\"></div><script>(function() { var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true; po.src = 'https://apis.google.com/js/plusone.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s); })();</script>
<div class=\"fb-like\" data-send=\"false\" data-layout=\"button_count\" data-width=\"60\" data-show-faces=\"true\"></div>
<a href=\"http://www.reddit.com/submit\" onclick=\"window.location = 'http://www.reddit.com/submit?url=' + encodeURIComponent(window.location); return false\"><img src=\"http://www.reddit.com/static/spreddit1.gif\" /></a>
</div>"
""
]

[
"<div id=\"disqus_thread\"></div><script>(function(){var dsq=document.createElement('script');dsq.type='text/javascript';dsq.async=true;dsq.src='http://xahlee.disqus.com/embed.js';(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);})();</script><a href=\"http://disqus.com\" class=\"dsq-brlink\">blog comments powered by <span class=\"logo-disqus\">Disqus</span></a>"
""
]

]
)

(replace-regexp-pairs-region (point-min) (point-max)
 [

;; Google analytics tracker
[ "<script>var _gaq = .+?</script>" "" ]

;; [ "<script><!--\ngoogle_ad_client[[:ascii:]]+?</script>" "" ]

;; ["<script type=\"text/javascript\"
;; src=\"http://pagead2.googlesyndication.com/pagead/show_ads.js\">
;; </script>"
;; ""]

["<div class=\"βds\">[[:ascii:]]+?</div>" ""]

["<div class=\"¤xd\">[^<]+?</div>" ""]

["<div class=\"¤\">[^<]+?</div>" ""]

;; 1 and 1
["<div class=\"¤1n1\">[^<]+?</div>" ""]

[ "<script charset=\"utf-8\" src=\"http://ws.amazon.com[^<]+?</script>" ""]

["<div class=\"¤tla\"><a href=\"\\([^\"]+?\\)\">\\([^<]+?\\)</a></div>" ""]

["<div class=\"ppp8745\"><form .+?</div></form></div>" ""]

["<script><!--
amazon_ad_tag .+?</script>
<script src=\"http://www.assoc-amazon.com/s/ads.js\"></script>" 
  ""]

;; ["<div id=\"disqus_thread\"></div><script>.+?</script><a href.+Disqus</span></a>" ""]
;; ["<footer>.+?</footer>" ""]

["\n\n+" "\n\n"]
  ]
                                   t t)

      ;; go thru each link, if the link is local, then check if the file exist. if not, replace the link with proper http://xahlee.org/ url
      (goto-char 1)
      (while (search-forward-regexp "<a href=\"" nil t)

        (forward-char 1)
        (setq bds (bounds-of-thing-at-point 'filename))
        (setq p1 (car bds))
        (setq p2 (cdr bds))
        (setq hrefValue (buffer-substring-no-properties p1 p2))

        (when (xahsite-local-link-p hrefValue)
          (setq default-directory (file-name-directory fPath) )
          (when (not (file-exists-p (elt (split-uri-hashmark hrefValue) 0)))
            (delete-region p1 p2)
            (insert (compute-url-from-relative-link originalFilePath hrefValue webRoot "ergoemacs.org"))
            )))

      (goto-char 1)
      (while (search-forward-regexp "<img src[[:blank:]]*=[[:blank:]]*" nil t)
        (forward-char 1)
        (setq bds (bounds-of-thing-at-point 'filename))
        (setq p1 (car bds))
        (setq p2 (cdr bds))
        (setq hrefValue (buffer-substring-no-properties p1 p2))

        (when (xahsite-local-link-p hrefValue)
          (setq default-directory (file-name-directory fPath) )
          (when (not (file-exists-p hrefValue))
            (delete-region p1 p2)
            (insert (compute-url-from-relative-link originalFilePath hrefValue webRoot "ergoemacs.org"))
            )))
      ) ))

(defun make-downloadable-copy (ξwebDocRoot ξsourceDirList ξdestDir )
  "Make a copy of a set of subdirs of Xah Site, for download.

All paths must be full paths.
All dir paths should end in slash. 

• ξwebDocRoot is the website doc root dir. e.g. “/Users/xah/web/xahlee_org/”

• ξsourceDirList is a list/sequence of dir paths to be copied for download. e.g. 
 [\"/Users/xah/web/xahlee_org/emacs/\" \"/Users/xah/web/xahlee_org/comp/\" ]
Each path should be a subdir of ξwebDocRoot.

• ξdestDir is the destination dir. e.g. 
 “/Users/xah/web/xahlee_org/diklo/emacs_tutorial_2012-05-05”
if exist, it'll be overridden.
"
  (let (
        ;; add ending slash, to be safe
        (ξwebDocRoot (file-name-as-directory (expand-file-name ξwebDocRoot))) 
        (ξdestDir (file-name-as-directory (expand-file-name ξdestDir)))
        (ξsourceDirList (mapcar (lambda (ξx) (file-name-as-directory (expand-file-name ξx))) ξsourceDirList) ) )
    
    ;; copy to destination
    (mapc
     (lambda (ξoneSrcDir)
       (let ((fromDir ξoneSrcDir)
             (toDir (concat ξdestDir (substract-path ξoneSrcDir ξwebDocRoot)) ))
         (make-directory toDir t)
         (if (>= emacs-major-version 24)
             (if (file-exists-p toDir)
                 (copy-directory fromDir (concat toDir "/../"))
               (copy-directory fromDir toDir) )
           (copy-directory fromDir toDir) )
         (princ (concat "Copying " fromDir " " toDir " …\n"))
         ))
     ξsourceDirList)

    ;; copy the style sheets over, and icons dir
    (copy-file "c:/Users/h3/web/xahlee_org/lbasic.css" ξdestDir)
    (copy-file "c:/Users/h3/web/xahlee_org/lit.css" ξdestDir)
    (copy-directory "c:/Users/h3/web/xahlee_org/ics/" (concat ξdestDir "ics/"))

    (xx-delete-temp-files ξdestDir)

    ;; change local links to “http://” links. Delete the google javascript snippet, and other small fixes.
    (princ "Removing javascript etc in files…\n")
    (mapc 
     (lambda (ξoneSrcDir)
       (mapc
        (lambda (ξf) (remove-ads-scripts-in-file ξf (concat ξwebDocRoot (substring ξf (length ξdestDir))) ξwebDocRoot))
        (find-lisp-find-files (concat ξdestDir (substract-path ξoneSrcDir ξwebDocRoot) ) "\\.html$")))
     ξsourceDirList)
    
    (princ "Making download copy completed.\n")
    )
  )



;; § ----------------------------------------
;; programing

;; (make-downloadable-copy
;;  "~/web/ergoemacs_org/"
;;  [
;;   "~/web/ergoemacs_org/emacs/"
;;   "~/web/ergoemacs_org/emacs_manual/"
;;   ]
;;  "~/web/xahlee_org/diklo/xah_emacs_tutorial/")

(make-downloadable-copy
 "~/web/"
 [
  "~/web/ergoemacs_org/"
  ]
 "~/web/xahlee_org/diklo/xx23/")

;; (make-downloadable-copy
;;  "c:/Users/h3/web/xahlee_org/"
;;  [ "c:/Users/h3/web/xahlee_org/js/" ]
;;  "c:/Users/h3/web/xahlee_org/diklo/xxxx3/")

;; (make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/js/" ]
;;  "~/web/xahlee_org/diklo/xah_dhtml_tutorial/")

;; (make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/java-a-day/" ]
;;  "~/web/xahlee_org/diklo/xah_java_tutorial/")

;; (make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/perl-python/" ]
;;  "~/web/xahlee_org/diklo/xah_perl-python_tutorial/")

;; ----------------------
;; math

;; (make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/Wallpaper_dir/" ]
;;  "~/web/xahlee_org/diklo/wallpaper_groups/")

;; ----------------------
;; literature


;; (make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/PageTwo_dir/Vocabulary_dir/" ]
;;  "~/web/xahlee_org/diklo/vocabulary/")

;; (make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/p/time_machine/" ]
;;  "~/web/xahlee_org/diklo/time_machine/")

;; (make-downloadable-copy "~/web/xahlee_org/" [ "~/web/xahlee_org/flatland/" ]  "~/xx283/")

;; (make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/p/titus/" ]
;;  "~/web/xahlee_org/diklo/titus/")

;; (make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/p/monkey_king/" ]
;;  "~/web/xahlee_org/diklo/monkey_king/")

;; (make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/p/arabian_nights/" ]
;;  "~/web/xahlee_org/diklo/arabian_nights/")

;; (make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/p/um/" ]
;;  "~/web/xahlee_org/diklo/unabomber_manifesto/")

;; (make-downloadable-copy
;;  "~/web/xahlee_org/"
;;  [ "~/web/xahlee_org/SpecialPlaneCurves_dir/" ]
;;  "~/web/xahlee_org/diklo/plane_curves_aw/")

