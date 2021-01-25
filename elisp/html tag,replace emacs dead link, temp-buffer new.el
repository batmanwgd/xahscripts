;; -*- coding: utf-8 -*-
;; 2011-09-25, 2012-05-11
;; replace dead links in emacs manual on my website
;;
;; Example. This:
;; <a href="../widget/index.html#Top">Introduction</a>
;;
;; should become this
;;
;; <span class="εlink" title="../widget/index.html">Introduction</span>
;;
;; do this for all files in a dir.

;; rough steps:
;; go thru each file
;; search for link
;; if the link is 「../‹…›」 where the file doesn't exist, then replace the whole link tag.

;; 〈Emacs Lisp: Fixing Dead Links〉
;; http://xahlee.org/emacs/elisp_fix_dead_links.html

(setq inputDir "~/web/xahlee_org/emacs_manual/" ) ; dir should end with a slash

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let ( urlStr linkText wholeLinkStr p1-linkTag p2-linkTag
                p3-linkTextBegin p4-linkTextEnd
                (ξcount 0)
                )

    ;; (princ (format "path: %s\n" fPath))
    (with-temp-buffer
      (insert-file-contents fPath)
      (goto-char (point-max)) ; work from bottom, so that changes in point are preserved. (actually, doesn't really matter for this script)

      (while (search-backward "<a href=\"../" nil t)
        (search-forward "<a href=\"") ; move inside the link
        (setq urlStr (replace-regexp-in-string "\\.html#.+" ".html" (thing-at-point 'filename) ) )
        ;; (princ (format "urlStr: %s\n" urlStr))

        (sgml-skip-tag-backward 1)
        (setq p1-linkTag (point) )
        (sgml-skip-tag-forward 1)
        (setq p2-linkTag (point) )
        (setq wholeLinkStr (buffer-substring-no-properties p1-linkTag p2-linkTag) )
        ;; (princ (format "wholeLinkStr: %s\n" wholeLinkStr))

        (when (not (file-exists-p (expand-file-name urlStr (file-name-directory fPath) )))
          (progn
            (search-backward "</a>")
            (setq p4-linkTextEnd (point) )
            (search-backward ">")
            (forward-char 1)
            (setq p3-linkTextBegin (point) )

            (setq linkText (buffer-substring-no-properties p3-linkTextBegin p4-linkTextEnd) )

            (delete-region p1-linkTag p2-linkTag)
            (insert (format "<span class=\"εlink\" title=\"%s\">%s</span>" urlStr linkText))
            (setq ξcount (1+ ξcount))
            ) )
        (goto-char p1-linkTag)          ; return cursor
        )

      (when (> ξcount 0)
        (copy-file fPath (concat fPath "~") t)
        (write-region (point-min) (point-max) fPath)
        (princ (format "◆ %d %s\n" ξcount fPath))
        ) )

    ) )

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*xah elisp dead link replace output*" )
  (with-output-to-temp-buffer outputBuffer
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )
