;; -*- coding: utf-8 -*-
;; 2011-10-10
;; change the page navigation bar on all html pages that has such a tag
;;
;; Example. This:
;; <div class="pgs">1, <a href="iraq_pixra2.html">2</a>, <a href="iraq_pixra3.html">3</a>, <a href="iraq_pixra4.html">4</a>, <a href="iraq_pixra5.html">5</a>, <a href="iraq_pixra6.html">6</a></div>
;; should become this:
;; <div id="pnavbar">
;; <a href="iraq_pixra1.html" title="page title">1</a>
;; <a href="iraq_pixra2.html" title="page title">2</a>
;; <a href="iraq_pixra3.html" title="page title">3</a>
;; <a href="iraq_pixra4.html" title="page title">4</a>
;; <a href="iraq_pixra5.html" title="page title">5</a>
;; <a href="iraq_pixra6.html" title="page title">6</a>
;; </div>

;; Note that the page itself now has a link. (the first line above)

;; rough steps:
;; go thru all html files in a dir
;; find file that contain <div class="pgs">
;; get all links in that line, put it in a list linkList (in order). Also add the current file's name to linkList in the position where there's no link.
;; delete that line.
;; generate a new tag.
;; insert the tag

;; to generate the new tag, go thru each element in linkList. The 「title="…"」 part must be each file's html title.

(setq inputDir "~/web/xahlee_org/Periodic_dosage_dir/t2/" ) ; dir should end with a slash
(setq inputDir "~/web/xahlee_org/" ) ; dir should end with a slash

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (myBuff p1 p2 (tagStringOriginal "") (resultTagStr "") )

    (setq myBuff (find-file fPath))

    (widen) (goto-char 1) ;; in case buffer already open

    (when (search-forward "<div class=\"pgs\">" nil t)
      (setq p1 (- (point) 17) )
        (search-forward "</div>" nil t)
      (setq p2 (point) )

      (setq tagStringOriginal (buffer-substring-no-properties p1 p2) )

      ;; construct new tag
      (goto-char p1)
      (let ( linkPath fTitle (ii 0) (tagList (split-string tagStringOriginal "," t)))
        (while (< ii (length tagList))
          (setq linkPath
                (if (string-match "<a href=\"\\([^\"]+?\\)\">" (elt tagList ii))
                    (match-string 1 (elt tagList ii))
                  (file-name-nondirectory fPath  )
                  )
                )
          (setq fTitle (get-html-file-title linkPath) )
          (setq resultTagStr (concat resultTagStr "<a href=\"" linkPath "\" title=\"" fTitle "\">" (format "%d" (1+ ii)) "</a>\n") )
          (setq ii (1+ ii) )
          )
        )
      (setq resultTagStr (concat "<div id=\"pnavbar\">\n"  resultTagStr "</div>" ) )

      (delete-region p1 p2)
      (insert resultTagStr)

      (progn 
        (princ "-------------------------------------------\n")
        (princ (format "%s\n\n%s\n\n%s\n" fPath tagStringOriginal resultTagStr))
        )
       )
    
    (when (not (buffer-modified-p myBuff)) (kill-buffer myBuff) )

    ) )

(require 'find-lisp)

(global-font-lock-mode 0)
(recentf-mode 0)

(let (outputBuffer)
  (setq outputBuffer "*xah page navbar replace output*" )
  (with-output-to-temp-buffer outputBuffer
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )

(global-font-lock-mode 1)
(recentf-mode 1)
