;; -*- coding: utf-8 -*-
;; 2012-03-05

;;  for a string A, if it happens more once or more, then, the file must also contain string B

(setq inputDir "~/web/xahlee_org/" ) ; must end with a slash

;; add a ending slash if not there
(when (not (string= "/" (substring inputDir -1))) (setq inputDir (concat inputDir "/")))

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (
        (ξi 0) ; count of strA
        (ξj 0) ; count of strB
        strA
        strB
        )
    (when (not (string-match "/xx" fPath))

      (setq strA "lang.css\">")
      (setq strB "lbasic.css\">")
      (setq case-fold-search nil)

      (with-temp-buffer
        (insert-file-contents fPath)

        (goto-char 1)
        (while (search-forward strA nil t)
          (setq ξi (1+ ξi)))

        (when (>= ξi 1)
          (when (/= ξi 1)
            (princ (format "ξi is: %d %s\n" ξi fPath)))

          (goto-char 1)
          (while (search-forward strB nil t)
            (setq ξj (1+ ξj)))

          (when (/= ξj 1)
            (princ (format "problem: %d %s\n" ξj fPath))))))))

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*xah occur output*" )
  (with-output-to-temp-buffer outputBuffer
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )
