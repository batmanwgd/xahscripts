;; -*- coding: utf-8 -*-
;; 2011-10-18
;; Remave pages with dstp tag.
;;
;; Example. This string:
;; <div class="dstp">2009-12</div>
;; which appears at the bottom, meaning date created, should be removed.

(setq inputDir "~/web/xahlee_org/sl" ) ; dir should end with a slash

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (myBuff p1 p2 p3 p4
               dateStr
               (dstpStr "") 
               )

    (setq myBuff (find-file fPath))

    (widen) (goto-char 1) ;; in case buffer already open

    (when (search-forward "<div class=\"dstp\">" nil t)
      (setq p1 (match-beginning 0) )
      (search-forward "</div>" nil t)
      (setq p2 (point) )
      (setq dstpStr (buffer-substring-no-properties p1 p2) )

      ;; (setq dstpStr (substring dstpStr 18) )
      ;; (setq dstpStr (substring dstpStr 0 -6) )

      ;; (setq dateStr dstpStr )
      ;; (setq dateStr (replace-regexp-in-string "^<div class=\"dstp\">" "" dateStr nil) )
      ;; (setq dstpStr (replace-regexp-in-string "</div>$" "" dateStr nil) )

      (setq dateStr (replace-regexp-in-string "^<div class=\"dstp\">" "" (replace-regexp-in-string "</div>$" "" dstpStr nil) nil) )

      (progn 
        (princ "-------------------------------------------\n")
        (princ (format "%s\n\n%s\n\n%s\n" fPath dstpStr dateStr))
        )
      )
    
    (when (not (buffer-modified-p myBuff)) (kill-buffer myBuff) )

    ) )

(require 'find-lisp)

(global-font-lock-mode 0)
(recentf-mode 0)

(let (outputBuffer)
  (setq outputBuffer "*xah page dstp replace output*" )
  (with-output-to-temp-buffer outputBuffer
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )

(global-font-lock-mode 1)
(recentf-mode 1)
