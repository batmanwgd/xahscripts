;; -*- coding: utf-8 -*-
;; 2012-02-11

;; fix all links of a given dir of html files.

;; for a web root dir, some subdir or files in it are moved.  This script takes the moved files/dirs as input, go thru all html files in web root dir, and correct all links.

;; • if the link is relative, the new path should also be relative
;; • if the link contain fragment id (e.g. hash char 「…#…」), the new path should also contain it

;; inputs:
;; • a root dir. e.g. 〔c:/Users/h3/web/〕
;; • a list of (from, to) dirs.
;; for each pair, the 1st element is the “from” node, the second is the destination node (the node itself, not the parent to move to under)

;; • the destination node must not exist.
;; • each “from” node must be unique, and must exist

;; algorithm
;; ① open each html files in a web root dir.
;; ② for each link 「<… href=…>」 and 「… src=…」, call this “xlink”
;; if xlink is a xah site (e.g.  http://ergoemacs.org/ , http://xahlee.org/ , may be relative link), then, generate the full path fo xlink (call this xfpath), assuming the dir structure BEFORE the dir move.
;; check if xfpath points to the moved dir/file, generate xfpath-new.
;; change the link in the file to use xfpath-new.

;; issues of link string:
;; it can be a url 〔http://ergoemacs.org/index.html〕
;; relative file path e.g.  〔../i/qi_logo.html〕
;; when url, it may not contain file name. e.g. 〔http://ergoemacs.org/〕
;; may contain fragment id 〔http://ergoemacs.org/some.html#section〕
;; may be relative link. e.g. 〔qi_logo.html〕, 〔../i/qi_logo.html〕



(defvar γinputPath nil "Input dir. Must end with a slash")
(setq γinputPath "/home/xah/web/xahlee_info/" )

;/home/xah/web/xahlee_org/sex/gender_feminist_of_the_year_Anita_Sarkeesian.html

(defvar γwriteToFile-p nil "whether to write to file.")
(setq γwriteToFile-p nil)

(defvar γdebug-p nil "Boolean. Print debug info.")
(setq γdebug-p nil )

(defun γcheck-this-link-p (linkString hostFilePath)
  "Return true or false.
This function can change arbitrarily. Its meant to be modified on-the-fly according to requirement.

linkString is the string of “href=…” value or “src=…” value.
hostFilePath is the file full path that contains the link."
t
  )

(defvar γskip-list nil "list of dirs to skip")
(setq γskip-list
      (mapcar
       (lambda (x) (concat (xahsite-server-root-path) "xahlee_info/" x))
       (xahsite-xahlee-info-external-docs)))

(defvar γmoveFromToList nil "A alist of dirs that are to be moved.
Each entry is of the form (‹from› . ‹to›).
• ‹from› and ‹to› must be full path.
• The ‹from› can be a file or dir.
• All dir paths must end with slash.
• If ‹from› is a dir, then ‹to› must also be a dir. Same for file.
• No ‹from› should be a subdir of each other.
• No “from” should be a identical to a “to” dir.
")

(setq γmoveFromToList
 '(

;; remove or regenerate ../wikipedia_links.html

;("/home/xah/web/xaharts_org/movie/stories_from_the_editorial_board_smart_robot.html" . "/home/xah/web/wordyenglish_com/chinese/stories_from_the_editorial_board_smart_robot.html")

;; ("c:/Users/h3/web/xahlee_org/sex/is_YouTube_porn_fodder.html" . "c:/Users/h3/web/xahlee_org/Periodic_dosage_dir/is_YouTube_porn_fodder.html")

;; ("c:/Users/h3/web/xaharts_org/funny/Microsoft_linux_ad.html" .
;; "c:/Users/h3/web/xahlee_info/funny/Microsoft_linux_ad.html"
;; )

;; http://xahlee.org/diklo/the_beauty_song.txt

;; http://xahlee.org/Periodic_dosage_dir/skina/apocalypse_now.html

;; ("c:/Users/h3/web/xahlee_org/Periodic_dosage_dir/lacru/index_batgirl_thumbnail.html" . "c:/Users/h3/web/xaharts_org/batgirl/index_batgirl_thumbnail.html")

;; ("c:/Users/h3/web/xahlee_org/Periodic_dosage_dir/lacru/_p/bg/" . "c:/Users/h3/web/xaharts_org/batgirl/i/")

;; ("c:/Users/h3/web/xahlee_org/Periodic_dosage_dir/lanci/i/na_tinbe/" . "c:/Users/h3/web/xahlee_org/Periodic_dosage_dir/lanci/i/sw/")

;; ("c:/Users/h3/web/xahlee_org/Periodic_dosage_dir/pirate_bay.html" . "c:/Users/h3/web/xahlee_info/comp/pirate_bay.html")

;("c:/Users/h3/web/xahlee_org/funny/condom_ad.html" . "c:/Users/h3/web/xahlee_org/sex/condom_ad.html")
;("c:/Users/h3/web/xaharts_org/funny/condom_ad.html" . "c:/Users/h3/web/xahlee_org/sex/condom_ad.html")

;("c:/Users/h3/web/xaharts_org/funny/4chan.html" . "c:/Users/h3/web/xahlee_org/funny/4chan.html")

;("c:/Users/h3/web/xahlee_org/Periodic_dosage_dir/american_socialism.html" . "c:/Users/h3/web/xaharts_org/funny/american_socialism.html")

;; no ad
;; c:/Users/h3/web/xaharts_org/funny/fredryk_phox.html
;; c:/Users/h3/web/xaharts_org/funny/breast_mouspad.html
;; c:/Users/h3/web/xaharts_org/funny/iMac_girl.html

;; i/mp/breast_mouse_pad3.jpg

   ))



(defvar γmovedFromPaths nil "The first elements of γmoveFromToList.")
(setq γmovedFromPaths (vconcat (mapcar (lambda (ξx) (car ξx) ) γmoveFromToList )) )

(defvar γbackup-filename-suffix nil "")
(setq γbackup-filename-suffix (concat "~s" (format-time-string "%Y%m%d_%H%M%S") "~"))



(defun get-new-fpath (φfPath φmoveFromToList)
  "Return a new file full path for φfPath.
φmoveFromToList is a alist."
  (let ((ξfoundResult nil) (ξi 0) (ξlen (length φmoveFromToList)))
    ;; compare to each moved dir.
    (while (and (not ξfoundResult) (< ξi ξlen))
      (when (string-match (concat "\\`" (regexp-quote (car (elt φmoveFromToList ξi)))) φfPath )
        (let (
              (fromDir (car (elt φmoveFromToList ξi)))
              (toDir (cdr (elt φmoveFromToList ξi))))
          (setq ξfoundResult (concat toDir (substract-path φfPath fromDir)))))
      (setq ξi (1+ ξi)))
    (if ξfoundResult ξfoundResult φfPath )))
;; (get-new-fpath "c:/Users/h3/web/xahlee_org/emacs/th" γmoveFromToList)
;; (get-new-fpath "c:/Users/h3/web/xahlee_org/emacs_manual/elisp/tt" γmoveFromToList)
;; (get-new-fpath "c:/Users/h3/web/xahlee_org/emacs" γmoveFromToList)



(defun fix-html-links (φhost-file-path φmove-from-to-list φmoved-from-paths &optional φwrite-to-file-p φdebug-p )
  "Process the file at FPATH …"
  (let (
        ρmatch-b
        ρmatch-e
        ρhrefValue-b
        ρhrefValue-e
        ρbeginTag-b ; begin tag begin. <
        ρbeginTag-e ; begin tag end. >

        ξhrefValue
        ξlinkFileFullPath
        (ξhostFileMoved-p nil)
        (ξlinkedFileMoved-p nil)
        ξlinkFragmentHead       ;the part before “#”
        ξlinkFragmentTail       ;the part after “#” including #
        ξnewHrefValue
        (ξneed-to-update-link-p nil)
        (ξchangeNecessary-p nil)
        )

    ;; open file, search for a “href=”
    (when
        ;; (not (string-match-p "/xx" φhost-file-path)) ; skip file whose name starts with “xx”
t
      (when φdebug-p (princ (format "\n▸φhost-file-path 「%s」\n" φhost-file-path ) ))
      (with-temp-buffer
        (insert-file-contents φhost-file-path)
        (while
            (search-forward-regexp "\\(href\\|src\\)=\"\\(?3:[^\"]+?\\)\"" nil t)
          (setq ρmatch-b (match-beginning 0) )
          (setq ρmatch-e (match-end 0) )
          (setq ρhrefValue-b (match-beginning 3) )
          (setq ρhrefValue-e (match-end 3) )
          (setq ξhrefValue (match-string 3))
          (save-excursion
            (search-backward "<" nil t)
            (setq ρbeginTag-b (point))
            (search-forward ">" nil t)
            (setq ρbeginTag-e (point))
            )

          ;; check if 「href="…"」 is inside <…>, and <…> doesn't contain any < or > character. If so, consider it's a link.
          (when (and (< ρbeginTag-b ρmatch-b) (< ρmatch-e ρbeginTag-e)
                     (not (string-match "<\\|>" (buffer-substring-no-properties (+ ρbeginTag-b 1) (- ρbeginTag-e 1) )) )
                     (not (string-match-p "\\`#" ξhrefValue ) ) ; skip links that's only http://en.wikipedia.org/wiki/Fragment_identifier
                     )

            (when φdebug-p (princ (format "▸ξhrefValue 「%s」\n" ξhrefValue ) ))

            (when  (xahsite-is-link-to-xahsite-p ξhrefValue)
              (progn
                (let ((x (split-uri-hashmark ξhrefValue)))
                  (setq ξlinkFragmentHead (elt x 0) )
                  (setq ξlinkFragmentTail (elt x 1) )
                  )

                (setq ξlinkFileFullPath
                      (if (xahsite-local-link-p ξhrefValue)
                          (expand-file-name ξlinkFragmentHead (file-name-directory φhost-file-path))
                        (xahsite-url-to-filepath ξlinkFragmentHead "addFileName")
                        ))
                (when φdebug-p (princ (format "▸ξlinkFileFullPath 「%s」\n" ξlinkFileFullPath ) ))

                (setq ξhostFileMoved-p (file-moved-p φhost-file-path φmoved-from-paths ))
                (setq ξlinkedFileMoved-p (file-moved-p ξlinkFileFullPath φmoved-from-paths ))
                (setq ξneed-to-update-link-p (or ξhostFileMoved-p ξlinkedFileMoved-p))

                (when φdebug-p (princ (format "▸ξhostFileMoved-p: 「%s」\n" ξhostFileMoved-p ) ))
                (when φdebug-p (princ (format "▸ξlinkedFileMoved-p: 「%s」\n" ξlinkedFileMoved-p ) ))
                (when φdebug-p (princ (format "▸ξneed-to-update-link-p: 「%s」\n" ξneed-to-update-link-p ) ))

                (when t                 ; ξneed-to-update-link-p
                  (setq ξnewHrefValue
                        (concat (xahsite-filepath-to-href-value
                                 (if ξlinkedFileMoved-p
                                     (get-new-fpath ξlinkFileFullPath φmove-from-to-list)
                                   ξlinkFileFullPath
                                   )
                                 (if ξhostFileMoved-p
                                     (get-new-fpath φhost-file-path φmove-from-to-list)
                                   φhost-file-path
                                   )
                                 ) ξlinkFragmentTail) )
                  (when φdebug-p (princ (format "▸ξnewHrefValue 「%s」\n" ξnewHrefValue ) ))

                  (when (not (string= ξhrefValue ξnewHrefValue) )
                    (setq ξchangeNecessary-p t )
                    (progn
                      (princ (format "  「%s」\n" ξhrefValue ) )
                      (princ (format "  『%s』\n" (replace-regexp-in-string "^c:/Users/h3/" "~/" ξnewHrefValue) ) )
                      )
                    (when φwrite-to-file-p
                      (delete-region ρhrefValue-b ρhrefValue-e )
                      (goto-char ρhrefValue-b)
                      (insert ξnewHrefValue) ) ) ) ) ) ) )

        (when ξchangeNecessary-p
          (princ (format "• %s\n" (replace-regexp-in-string "^c:/Users/h3/" "~/" φhost-file-path) ) )
          (when φwrite-to-file-p
            (copy-file φhost-file-path (concat φhost-file-path γbackup-filename-suffix) t) ; backup
            (write-region (point-min) (point-max) φhost-file-path)
            )  )) ) ))


(require 'find-lisp)

(let ((outputBuffer "*xah sitemove output*" ))
  (with-output-to-temp-buffer outputBuffer

    (princ (format "-*- coding: utf-8 -*-
%s, xah site move link change results. Input path: 〔%s〕 \n\n" (current-date-time-string) γinputPath))
    (if (file-regular-p γinputPath)
        (fix-html-links γinputPath γmoveFromToList γmovedFromPaths γwriteToFile-p γdebug-p)

      (progn
        (if (file-directory-p γinputPath)
            (mapc
             (lambda (ξf)
               (fix-html-links ξf γmoveFromToList γmovedFromPaths γwriteToFile-p γdebug-p))

             (xah-filter-list
              (lambda (φh) (not (xah-string-match-in-list-p φh γskip-list "match case" t)))
              (find-lisp-find-files γinputPath "\\.html\\'\\|\\.xml\\'"))

             ;; (xah-filter-list
             ;;  (lambda (φh) (not (xah-string-match-in-list-p φh γskip-list "match case" t)))
             ;;  '("/home/xah/web/xahlee_info/php/php_install.html"
             ;;    "/home/xah/web/xahlee_info/css_2.1_spec/"
             ;;    "/home/xah/web/xahlee_info/css_2.1_spec/propidx.html"
             ;;    "/home/xah/web/xahlee_info/php/keyed_list.html"
             ;;    "/home/xah/web/xahlee_info/php/list_basics.html"
             ;;    "/home/xah/web/xahlee_info/php/send_html_mail.html"
             ;;    "/home/xah/web/xahlee_info/php/loop_thru_list.html"
             ;;    "/home/xah/web/xahlee_info/php/mysql.html"
             ;;    "/home/xah/web/xahlee_info/php/misc.html" ))

             ;; (find-lisp-find-files γinputPath "\\.html\\'\\|\\.xml\\'")

             )
          (error "Input path 「%s」 isn't a regular file nor dir." γinputPath))))
    (princ "Done ☺")
    (switch-to-buffer outputBuffer)
    (html-mode)
    (highlight-lines-matching-regexp "\\`• " (quote hi-pink))
    )
  )
