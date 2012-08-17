;; -*- coding: utf-8 -*-
;; 2011-09-25
;; replace dead links in emacs manual on my website
;;
;; Example. This:
;; <a href="../widget/index.html#Top">Introduction</a>
;;
;; should become this
;;
;; <span class="εlink" title="../widget/index.html#Top">Introduction</span>
;;
;; do this for all files in a dir.

;; rough steps:
;; go thru each file
;; search for link
;; if the link is 「../xx/」 where the file doesn't exist, then replace the whole link tag.

;; 〈Emacs Lisp: Fixing Dead Links〉
;; http://xahlee.org/emacs/elisp_fix_dead_links.html

(setq inputDir "~/web/xahlee_org/emacs_manual/" ) ; dir should end with a slash

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (
        myBuff
        urlStr
        linkText
        wholeLinkStr
        p1 p2
        p3 p4
        )
    (setq myBuff (find-file fPath))
    (widen) ; in case it's open and narrowed
    (goto-char (point-max)) ; work from bottom, so that changes in point are preserved. (actually, doesn't really matter for this script)

    (while
        (search-backward "href=\"../" nil t)
      (forward-char 7)
      (setq urlStr (replace-regexp-in-string "\\.html#.+" ".html" (thing-at-point 'filename) ) )

      (when (not (file-exists-p urlStr))
        (progn
          (sgml-skip-tag-backward 1)
          (setq p1 (point) ) ; start of link tag
          (sgml-skip-tag-forward 1)
          (setq p2 (point) ) ; end of link tag

          (setq wholeLinkStr (buffer-substring-no-properties p1 p2) )

          (search-backward "</a>")
          (setq p4 (point) ) ; end of link text
          (search-backward ">")
          (forward-char 1)
          (setq p3 (point) ) ; start of link text

          (setq linkText (buffer-substring-no-properties p3 p4) )

          (princ (buffer-file-name))
          (princ "\n")
          (princ wholeLinkStr)
          (princ "\n")
          (princ "----------------------------\n")

          (delete-region p1 p2)
          (insert 
           "<span class=\"εlink\" title=\""
           urlStr
           "\">"
           linkText
           "</span>"
           )
          )
        )
      )
    
    (when (not (buffer-modified-p myBuff)) (kill-buffer myBuff) )

    ) )

(require 'find-lisp)

(global-font-lock-mode 0)

(let (outputBuffer)
  (setq outputBuffer "*xah elisp dead link replace output*" )
  (with-output-to-temp-buffer outputBuffer
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )

(global-font-lock-mode 1)
