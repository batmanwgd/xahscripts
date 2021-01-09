;; -*- coding: utf-8; lexical-binding: t; -*-
;; 2013-07-15
;; 2017-05-31

;; (require 'dired-x)
;; (require 'dired-aux)
;; (require 'grep)
;; (provide 'ido)
;; (provide 'simple)



(defvar ξallSymbols '() "list of symbols we want to get doc string")
(setq ξallSymbols '())

(defvar ξsymbol-hashtable nil "hash table of symbols we want to get doc string")
(setq ξsymbol-hashtable (make-hash-table :test 'equal))

;; (mapatoms (lambda (x) (push x ξallSymbols)) obarray )

;; the problem with generating doc from all symbols in obarray is that, most symbols there are not actually used. You get many obscure functions or symbols. But also, some function should be there but are not, eg , eval-last-sexp, ielm, describe-function.
;; so, solution is to filter. but the problem is how.
;; for example, needs to filter cl- , ...
;; ok, another solution, is to grep and get all symbols mentioned in both emacs manual and elisp manual
;; then, filter based on those.

;; example, from emacs manual
;; variable <code>message-log-max</code>

;; list of files to read in. each contain symbols
(setq
 ξmyfiles
 '(

;; "elisp_command_2016-12-21"
;;    "elisp_function_2016-12-21"
;;    "elisp_macro_2016-12-21"
;;    "elisp_special_form_2016-12-21"

"emacs_manual_fboundp_2017-01-08"

   ;; "elisp_constant_2016-12-21"
   ;; "elisp_user_option_2016-12-21"
   ;; "elisp_var_2016-12-21"
   ))

(defvar ξoutfile nil "string. output file name")
(setq ξoutfile "func_doc_string_out.txt")

;; add them all to ξallSymbols
(dolist (file ξmyfiles )
  (setq
   ξallSymbols
   (append ξallSymbols
           (with-temp-buffer
             (insert-file-contents file)
             (split-string (buffer-string) "\n" t)) nil)))

;; convert the list of string to list of symbols
(setq ξallSymbols (mapcar 'intern ξallSymbols))

;; generate doc string
(with-temp-file ξoutfile
  (mapc
   (lambda (ff)
     (when (fboundp ff)
       (let ((fdoc (documentation ff)))
         (insert (format
                  "〈〈%s〉〉:〈〈%s〉〉enditem49840"
                  ff
                  fdoc)))))
   ξallSymbols))

(progn
  ;; process the doc string

  ;; goal: generate a json format of elisp doc strings
  ;; of the form
  ;; {
  ;; "fname-1":"doc string 1",
  ;; "fname-2":"doc string 2",
  ;; ...
  ;; "fname-n":"doc string n",
  ;; }

  (find-file ξoutfile)

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
    (while (search-forward "enditem49840" nil t) (replace-match ",\n"))

    (goto-char (point-min))
    (insert "{")

    (goto-char (point-max))
    (insert "}")
    ;;

    ))

