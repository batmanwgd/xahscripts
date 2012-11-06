;; -*- coding: utf-8 -*-
;; elisp
;; 2012-02-01
;; check links of all html files in a dir

;; check only local file links in text patterns of the form:
;; < … href="link" …>
;; < … src="link" …>

(setq inputDir "~/web/xahlee_org/" ) ; dir should end with a slash

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let ( ξurl ξpath p1 p2 p-current p-mb (checkPathQ nil) )

    ;; open file
    ;; search for a “href=” or “src=” link
    ;; check if that link points to a existing file
    ;; if not, report it

    (when (not (string-match "/xx" fPath)) ; skip file whose name starts with “xx”
      (with-temp-buffer
        (insert-file-contents fPath)
        (while
            (search-forward-regexp "\\(?:href\\|src\\)[ \n]*=[ \n]*\"\\([^\"]+?\\)\"" nil t)
          (setq p-current (point) )
          (setq p-mb (match-beginning 0) )
          (setq ξurl (match-string 1))

          (save-excursion 
            (search-backward "<" nil t)
            (setq p1 (point))
            (search-forward ">" nil t)
            (setq p2 (point))
            )

          (when (and (< p1 p-mb) (< p-current p2) ) ; the “href="…"” is inside <…>
            ;; set checkPathQ to true for non-local links and xahlee site e.g. http://xahlee.info/
            (if (string-match "^http://\\|^https://\\|^mailto:\\|^irc:\\|^ftp:\\|^javascript:" ξurl)
                (when (string-match "^http://xahlee\.org\\|^http://xahlee\.info\\|^http://ergoemacs\.org\\|^http://xahporn\.org" ξurl)
                  (setq ξpath (xahsite-url-to-filepath (replace-regexp-in-string "#.+$" "" ξurl))) ; remove trailing jumper url. e.g. href="…#…"
                  (setq checkPathQ t)
                  )
              (progn
                (setq ξpath (replace-regexp-in-string "%27" "'" (replace-regexp-in-string "#.+$" "" ξurl)) )
                (setq checkPathQ t)
                )
              )

            (when checkPathQ
              (when (not (file-exists-p (expand-file-name ξpath (file-name-directory fPath))))
                (princ (format "• %s %s\n" (replace-regexp-in-string "^c:/Users/h3" "~" fPath) ξurl) )
                )
              (setq checkPathQ nil) )

            ) ) ) ) ) )

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*xah check links output*" )
  (with-output-to-temp-buffer outputBuffer
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )
