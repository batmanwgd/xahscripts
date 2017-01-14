;; -*- coding: utf-8; lexical-binding: t; -*-
;; 2013-07-15



(setq
 γmyfiles
 '("elisp_command_2016-12-21"
   ;; "elisp_constant_2016-12-21"
   "elisp_function_2016-12-21"
   "elisp_macro_2016-12-21"
   "elisp_special_form_2016-12-21"
   ;; "elisp_user_option_2016-12-21"
   ;; "elisp_var_2016-12-21"
   ))

(defvar γallSymbols '() "all symbols in obarray")

(setq γallSymbols '())

(dolist (file γmyfiles )
  (setq
   γallSymbols
   (append γallSymbols
           (with-temp-buffer
             (insert-file-contents file)
             (split-string (buffer-string) "\n" t)))))

(setq γallSymbols (mapcar 'intern γallSymbols))

(with-temp-file "xxx1.txt"
  (mapc
   (lambda (ff)
     (when (fboundp ff)
       (let ((fdoc (documentation ff)))
         (insert (format
                  "〈〈%s〉〉:〈〈%s〉〉enditem49840"
                  ff
                  fdoc)))))
   γallSymbols))

(find-file "tooltip_content_out.txt")

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
