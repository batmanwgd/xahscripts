;; -*- coding: utf-8; lexical-binding: t; -*-
;; 2013-07-15
;; 2017-05-31

;; (require 'dired-x)
;; (require 'dired-aux)
;; (require 'grep)
;; (provide 'ido)
;; (provide 'simple)



;; (defvar $allSymbols '() "list of symbols we want to get doc string")
;; (setq $allSymbols '())
;; (mapatoms (lambda (x) (push x $allSymbols)) obarray )

(defvar $symTable nil "hash table of symbols we want to get doc string")
(setq $symTable (make-hash-table :test 'equal))

;; the problem with generating doc from all symbols in obarray is that, most symbols there are not actually used. You get many obscure functions or symbols. But also, some function should be there but are not, eg , eval-last-sexp, ielm, describe-function.
;; so, solution is to filter. but the problem is how.
;; for example, needs to filter cl- , ...
;; ok, another solution, is to grep and get all symbols mentioned in both emacs manual and elisp manual
;; then, filter based on those.

;; example, from emacs manual
;; variable <code>message-log-max</code>

;; list of files to read in. each contain symbols
(setq
 $myfiles
 '(

   "elisp_command_2016-12-21"
   ;; "elisp_function_2016-12-21"
   ;; "elisp_macro_2016-12-21"
   ;; "elisp_special_form_2016-12-21"
   ;; "emacs_manual_fboundp_2017-01-08"

   ;; "elisp_constant_2016-12-21"
   ;; "elisp_user_option_2016-12-21"
   ;; "elisp_var_2016-12-21"
   ))

(defvar $outfile nil "string. output file name")
(setq $outfile "func_doc_string_out2")

;; add them all to symbols hash
(dolist (x $myfiles )
  (mapc
   (lambda (x)
     (puthash x 1 $symTable ))
   (with-temp-buffer
     (insert-file-contents x)
     (split-string (buffer-string) "\n" t))))

(message "total sym: %s" (hash-table-count $symTable))

(write-region "" nil $outfile)

;; (documentation 'describe-bindings)

;; (intern-soft "x1")
;; (intern-soft "x2")

;; (eq 'x1 'x2)

;; gen doc string
(maphash
 (lambda (key _)
   (let* ((sym (intern key))
          symdoc lastl output)
     (when (fboundp sym)
       (setq symdoc (documentation sym t))
       (with-temp-buffer
         (if symdoc
             (progn
               (insert symdoc)
               (goto-char (point-max))
               (beginning-of-line)
               (if (re-search-forward "(fn" nil t)
                   (progn
                     (delete-char -2)
                     (insert (format "%s" sym))
                     (setq lastl (delete-and-extract-region (line-beginning-position) (line-end-position)))
                     (insert "15254-----")
                     (goto-char 1)
                     (insert lastl "\n"))
                 (progn
                   (goto-char 1)
                   (insert (format "%s\n" sym)))))
           (error "nodoc: %s" sym))
         (append-to-file (point-min) (point-max) $outfile)))))
 $symTable)

(progn
  ;; post process the doc string file

  ;; goal: generate a json format of elisp doc strings
  ;; of the form
  ;; {
  ;; "fname-1":"doc string 1",
  ;; "fname-2":"doc string 2",
  ;; ...
  ;; "fname-n":"doc string n",
  ;; }

  ;; (with-temp-buffer
  ;;   (insert-file-contents $outfile)
  ;;   (let ((case-fold-search nil))

  ;;     ;; emacs doc string contains line breaks. js string does not allow. Solution: use a dummy char ¶, then in js, replace ¶¶ by </br></br> then replace ¶ by one space
  ;;     (goto-char (point-min))
  ;;     (while (search-forward "\n" nil t) (replace-match "¶"))

  ;;     ;; escape html. e.g. emacs has “&option” often.
  ;;     (goto-char (point-min))
  ;;     (while (search-forward "&" nil t) (replace-match "&amp;"))

  ;;     (goto-char (point-min))
  ;;     (while (search-forward "<" nil t) (replace-match "&lt;"))

  ;;     (goto-char (point-min))
  ;;     (while (search-forward ">" nil t) (replace-match "&gt;"))

  ;;     ;; doc string contains " or \" or with multiple backslashes solution: replace them “&quot;”
  ;;     ;; put back quote
  ;;     (goto-char (point-min))
  ;;     (while (search-forward "\"" nil t) (replace-match "&quot;"))

  ;;     ;; emacs has lots backslash. but it also has meaning in js string. Replace it by a similar looking unicode char
  ;;     ;; alternative is to double the backslash, but that gets really ugly
  ;;     (goto-char (point-min))
  ;;     (while (search-forward "\\" nil t) (replace-match "&#x5c;"))

  ;;     ;; emacs doc string contains literal tab. json does not allow.
  ;;     (goto-char (point-min))
  ;;     (while (search-forward "	" nil t) (replace-match "\\t" "FIXEDCASE" "LITERAL"))

  ;;     ;; add quote to the key name and value string
  ;;     (goto-char (point-min))
  ;;     (while (search-forward "〈〈" nil t) (replace-match "\""))
  ;;     (goto-char (point-min))
  ;;     (while (search-forward "〉〉" nil t) (replace-match "\""))

  ;;     (goto-char (point-min))
  ;;     (while (search-forward "enditem49840" nil t) (replace-match ",\n"))

  ;;     (goto-char (point-min))
  ;;     (insert "{")

  ;;     (goto-char (point-max))
  ;;     (insert "}")
  ;;     ;;

  ;;     (write-region (point-min) (point-max) $outfile )))
  )

