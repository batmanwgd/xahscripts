; -*- coding: utf-8 -*-

; 2010-03-11
; find files that contains a string with particular conditions.

; basically, in html files, i want to find a navigation bar that doesn't end in a period.

; find any text of this pattern “<div class="nav">...</div>”
; and report any substring that is “</a></div>”.

; note: the exact nav bar string is not the same for all files.

(setq inputDir "c:/Users/xah/web/xahlee_org/" ) ; dir should end with a slash

; functions

; open a file, process it
(defun my-process-file (fpath)
  "process the file at fullpath fpath ..."
  (let (mybuffer p1 p2 p3 (ii 0))

    (when (and (not (string-match "/xx" fpath))
               (not (string-match "/more\\.html" fpath))
               )
 
      (setq mybuffer (find-file fpath))
      (goto-char 1) ;; in case buffer already open

      (when (search-forward "<div class=\"nav\">" nil t)
        (search-backward "\n")
        (forward-char)
        (setq p1 (point))
        (search-forward "\n")
        (backward-char)
        (setq p2 (point))
        (goto-char p1)

        (when (search-forward "</a></div>" p2 t)
          (message "problem: %s" fpath)

          )
        )

      (kill-buffer mybuffer)
      )
))


; main

(desktop-save-mode 0)

(require 'find-lisp)
(mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))

(message "Done deal!")