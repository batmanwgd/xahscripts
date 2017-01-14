;; -*- coding: utf-8; lexical-binding: t; -*-
;; 2013-07-15

(require 'dired-x)
(provide 'dired-aux)
(require 'grep)
(provide 'ido)
(provide 'simple)



(defvar γallSymbols '() "all symbols in obarray")

(mapatoms
 (lambda (x)
   (push x γallSymbols))
 obarray
 )

;; the problem with generating doc from all symbols in obarray is that, most symbols there are not actually used. You get many obscure functions or symbols. But also, some function should be there but are not, eg , eval-last-sexp, ielm, describe-function.
;; so, solution is to filter. but the problem is how.
;; for example, needs to filter cl- , ... 
;; ok, another solution, is to grep and get all symbols mentioned in both emacs manual and elisp manual
;; then, filter based on those.

;; example, from emacs manual
;; variable <code>message-log-max</code>

(length γallSymbols )
;; 46694. on gnu emacs sans init, about 15k

;; (setq γallSymbols
;;       '(
;;         mouse-on-link-p
;;         macrop
;;         run-hooks
;;         run-hook-with-args
;;         run-hook-with-args-until-failure
;;         run-hook-with-args-until-success
;;         define-fringe-bitmap
;;         destroy-fringe-bitmap
;;         ))



(with-temp-file "xx1.txt"
  (mapc
   (lambda (ff)
     (message "%s" ff)
     (when (and  (fboundp ff)
                 (not (string-match "^cl-" (symbol-name ff))))
       (let ((fdoc (documentation ff)))
         (insert (format
                  "〈〈%s〉〉:〈〈%s〉〉enditem49840"
                  ff
                  fdoc)))))
   γallSymbols))

;; (documentation 'cl-struct-js--pitem)
;; (documentation 'eieio-class-tag--xref-bogus-location)
;; progn: Invalid function: nil

(find-file "xx2.txt")

;; goal: generate a json format of elisp doc strings
;; of the form
 ;; {
;; "fname-1":"doc string 1",
;; "fname-2":"doc string 2",
;; ...
;; "fname-n":"doc string n",
;; }

(let ((case-fold-search nil))

  ;; emacs doc string contains line breaks. js string does not allow. Solution: use a dummy char ¶, then in js, replace ¶¶ by </br></br> then replace ¶ by one space
  (goto-char (point-min))
  (while (search-forward "\n" nil t) (replace-match "¶"))

  ;; escape html. e.g. emacs has “&option” often.
  (goto-char (point-min))
  (while (search-forward "&" nil t) (replace-match "&amp;"))

  (goto-char (point-min))
  (while (search-forward "<" nil t) (replace-match "&lt;"))

  (goto-char (point-min))
  (while (search-forward ">" nil t) (replace-match "&gt;"))

  ;; doc string contains " or \" or with multiple backslashes solution: replace them “&quot;”
  ;; put back quote
  (goto-char (point-min))
  (while (search-forward "\"" nil t) (replace-match "&quot;"))

  ;; emacs has lots backslash. but it also has meaning in js string. Replace it by a similar looking unicode char
  ;; alternative is to double the backslash, but that gets really ugly
  (goto-char (point-min))
  (while (search-forward "\\" nil t) (replace-match "⧷"))

  ;; emacs doc string contains literal tab. json does not allow.
  (goto-char (point-min))
  (while (search-forward "	" nil t) (replace-match "\\t" "FIXEDCASE" "LITERAL"))

  ;; add quote to the key name and value string
  (goto-char (point-min))
  (while (search-forward "〈〈" nil t) (replace-match "\""))
  (goto-char (point-min))
  (while (search-forward "〉〉" nil t) (replace-match "\""))

  (goto-char (point-min))
  (while (search-forward "enditem49840" nil t) (replace-match ",\n")))

  (goto-char (point-min))
(insert "{")

  (goto-char (point-max))
(insert "}")

;; (setq fdoc (replace-regexp-in-string "\n" "•" fdoc "FIXEDCASE" "LITERAL") )
;; (setq fdoc (replace-regexp-in-string "<" "&lt;" fdoc "FIXEDCASE" "LITERAL") )
;; (setq fdoc (replace-regexp-in-string ">" "&gt;" fdoc "FIXEDCASE" "LITERAL") )
;; (setq fdoc (replace-regexp-in-string "&" "&amp;;" fdoc "FIXEDCASE" "LITERAL") )

;; < > & needs to be encoded as HTML entities
;; " needs to be escaped
