;; -*- coding: utf-8; lexical-binding: t; -*-
;; 2017-01-08

;; (xah-find-replace-text-regex "variable <code>\\([-A-Za-z0-9]+\\)</code>" "variable <var>\\1</var>" "/home/xah/web/ergoemacs_org/emacs_manual/" "\\.html\\'" nil t t)

;; walk emacs and elisp manual pages
;; find any <code>‹word›</code>
;; if ‹word› is fboundp, replace it with
;; <code class="elisp-ƒ">‹word›</code>
;; if ‹word› is boundp, replace it with
;; <var class="elisp">‹word›</var>

(defun my-process-file (@fpath)
  "Process the file at path FPATH …"
  (let (
        ($fileChanged-p nil)
        $symbol $symstr
        )
    (print (format "-------------------------------------------\n %s" @fpath))
    (with-temp-buffer
      (insert-file-contents @fpath)
      (goto-char (point-min))

      (while (re-search-forward "<code>\\([-A-Za-z0-9]+\\)</code>" nil 'NOERROR )
        (progn

          (setq $symstr (match-string 1))

          ;; (fboundp 'define-widget)
          ;; (intern-soft 'define-widget )
          (when (setq $symbol (intern-soft $symstr ))
            (print (format "%s" $symbol ))

            (if (fboundp $symbol)
                (progn
                  (search-backward "<code>" )
                  (replace-match "<code class=\"elisp-ƒ\">" )
                  (message "%s change" $symbol)
                  (print (format "%s function" $symbol))
                  (setq $fileChanged-p t))
              (if (boundp $symbol)
                  (progn
                    (search-backward "</code>" )
                    (replace-match "</var>" )
                    (search-backward "<code>" )
                    (replace-match "<var class=\"elisp\">" )
                    (print (format "%s var" $symbol))
                    (setq $fileChanged-p t))
                nil)))))
      (when $fileChanged-p (write-region 1 (point-max) @fpath)) ;
      )))

;; traverse a dir

(require 'find-lisp)

;; insert file path of all html files in the directory, recursive all sub-directory
(with-output-to-temp-buffer "*process emacs manual out*"

  (mapc

   'my-process-file

   (find-lisp-find-files
    "/home/xah/web/ergoemacs_org/emacs_manual/"
    "\\.html$"
    )))
