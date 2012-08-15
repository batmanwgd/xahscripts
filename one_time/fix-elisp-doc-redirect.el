; 2008-06-21

;; many emacs lisp manual files whose whole line is meta redirect.
;; this is invalid html.
;; this script adds proper html header tags to these files to make them valid.
;;   Xah
;; ∑ http://xahlee.org/

;; traverse html files
;; open each
;; check if it starts meta
;; if so, replace the file content
;; save.


; open a file, process it, save, close it
(defun my-process-file (fpath)
  "process the file at fullpath fpath ..."
  (let (mybuffer firstLine)
    (setq mybuffer (find-file fpath))
    (buffer-disable-undo) ;; no need undo
    (goto-char (point-min)) ;; in case buffer already open
    (setq firstLine (thing-at-point 'line))

    (when (and
           (string-equal
            (substring firstLine 0 27)
            "<meta http-equiv=\"refresh\" ")
           (y-or-n-p "Change this file?")
           )
      (insert "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2 Final//EN\">
<html><head>
")
      (goto-char (point-max))
      (insert "<title>redirect</title></head><body></body></html>\n")
      (save-buffer)
      )
    (kill-buffer mybuffer)))

; testing on a single file
;(my-process-file "/Users/xah/web/elisp/Coding-systems-for-a-subprocess.html")

; idiom for traversing a directory
(require 'find-lisp)
(mapc 'my-process-file (find-lisp-find-files "~/web/elisp" "\\.html$"))

