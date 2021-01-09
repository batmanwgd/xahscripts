;; -*- coding: utf-8; lexical-binding: t; -*-
;; 2013-07-15


(fboundp 'mouse-on-link-p)

(setq fnames
      (list
       'mouse-on-link-p
       'macrop
       ;; todo. read in a file of function names, or auto generate from emacs in some way
       ))

(descFunc87801 ) 

(defun descFunc87801 (function)
  "Display the full documentation of FUNCTION (a symbol)."
  (interactive
   (let ((fn (function-called-at-point))
	 (enable-recursive-minibuffers t)
	 val)
     (setq val (completing-read (if fn
				    (format "Describe function (default %s): " fn)
				  "Describe function: ")
				obarray 'fboundp t nil nil
				(and fn (symbol-name fn))))
     (list (if (equal val "")
	       fn (intern val)))))
  (if (null function)
      (message "You didn't specify a function")
    (help-setup-xref (list #'descFunc87801 function)
		     (called-interactively-p 'interactive))
    (save-excursion
      (with-help-window (help-buffer)
	(prin1 function)
	;; Use " is " instead of a colon so that
	;; it is easier to get out the function name using forward-sexp.
	(princ " is ")
	(describeFunction77838 function)
	(with-current-buffer standard-output
	  ;; Return the text we displayed.
	  (buffer-string))))))

(defun describeFunction77838 (function)
  (let* ((advised (and (symbolp function) (featurep 'advice)
		       (ad-get-advice-info function)))
	 ;; If the function is advised, use the symbol that has the
	 ;; real definition, if that symbol is already set up.
	 (real-function
	  (or (and advised
		   (let ((origname (cdr (assq 'origname advised))))
		     (and (fboundp origname) origname)))
	      function))
	 ;; Get the real definition.
	 (def (if (symbolp real-function)
		  (symbol-function real-function)
		function))
	 (aliased (symbolp def))
	 (real-def (if aliased
		       (let ((f def))
			 (while (and (fboundp f)
				     (symbolp (symbol-function f)))
			   (setq f (symbol-function f)))
			 f)
		     def))
	 (file-name (find-lisp-object-file-name function def))
         (pt1 (with-current-buffer (help-buffer) (point)))
	 (beg (if (and (or (byte-code-function-p def)
			   (keymapp def)
			   (memq (car-safe def) '(macro lambda closure)))
		       file-name
		       (help-fns--autoloaded-p function file-name))
		  (if (commandp def)
		      "an interactive autoloaded "
		    "an autoloaded ")
		(if (commandp def) "an interactive " "a "))))

    ;; Print what kind of function-like object FUNCTION is.
    (princ (cond ((or (stringp def) (vectorp def))
		  "a keyboard macro")
		 ((subrp def)
		  (if (eq 'unevalled (cdr (subr-arity def)))
		      (concat beg "special form")
		    (concat beg "built-in function")))
		 ((byte-code-function-p def)
		  (concat beg "compiled Lisp function"))
		 (aliased
		  (format "an alias for `%s'" real-def))
		 ((eq (car-safe def) 'lambda)
		  (concat beg "Lisp function"))
		 ((eq (car-safe def) 'macro)
		  (concat beg "Lisp macro"))
		 ((eq (car-safe def) 'closure)
		  (concat beg "Lisp closure"))
		 ((autoloadp def)
		  (format "%s autoloaded %s"
			  (if (commandp def) "an interactive" "an")
			  (if (eq (nth 4 def) 'keymap) "keymap"
			    (if (nth 4 def) "Lisp macro" "Lisp function"))))
		 ((keymapp def)
		  (let ((is-full nil)
			(elts (cdr-safe def)))
		    (while elts
		      (if (char-table-p (car-safe elts))
			  (setq is-full t
				elts nil))
		      (setq elts (cdr-safe elts)))
		    (concat beg (if is-full "keymap" "sparse keymap"))))
		 (t "")))

    (if (and aliased (not (fboundp real-def)))
	(princ ",\nwhich is not defined.  Please make a bug report.")
      (with-current-buffer standard-output
	(save-excursion
	  (save-match-data
	    (when (re-search-backward "alias for `\\([^`']+\\)'" nil t)
	      (help-xref-button 1 'help-function real-def)))))

      (when file-name
	(princ " in `")
	;; We used to add .el to the file name,
	;; but that's completely wrong when the user used load-file.
	(princ (if (eq file-name 'C-source)
		   "C source code"
		 (file-name-nondirectory file-name)))
	(princ "'")
	;; Make a hyperlink to the library.
	(with-current-buffer standard-output
	  (save-excursion
	    (re-search-backward "`\\([^`']+\\)'" nil t)
	    (help-xref-button 1 'help-function-def function file-name))))
      (princ ".")
      (with-current-buffer (help-buffer)
	(fill-region-as-paragraph (save-excursion (goto-char pt1) (forward-line 0) (point))
				  (point)))
      (terpri)(terpri)

      (let* ((doc-raw (documentation function t))
	     ;; If the function is autoloaded, and its docstring has
	     ;; key substitution constructs, load the library.
	     (doc (progn
		    (and (autoloadp real-def) doc-raw
			 help-enable-auto-load
			 (string-match "\\([^\\]=\\|[^=]\\|\\`\\)\\\\[[{<]"
				       doc-raw)
			 (load (cadr real-def) t))
		    (substitute-command-keys doc-raw))))

        ;; (help-fns--key-bindings function)
        (with-current-buffer standard-output
          (setq doc (help-fns--signature function doc real-def real-function))

          (help-fns--compiler-macro function)
          (help-fns--parent-mode function)
          (help-fns--obsolete function)

          (insert "\n"
                  (or doc "Not documented.")))))))


(with-temp-file "xxx.txt"
  (mapc
   (lambda (fn-59908)

     (when (fboundp fn-59908)
       (let ((uuu (descFunc87801 fn-59908)))
         (insert (format "〈〈%s〉〉:〈〈%s〉〉•85170" fn-59908 (replace-regexp-in-string "\"" "\\\"" uuu "FIXEDCASE" "LITERAL") ) ) ) )
     )
   fnames)
  )

(find-file "xxx.txt")

(let ((case-fold-search nil))

  ;; escape JavaScript string
  (goto-char (point-min))
  (while (search-forward "\n" nil t) (replace-match "•"))

  ;; escape html
  (goto-char (point-min))
  (while (search-forward "&" nil t) (replace-match "&amp;"))

  (goto-char (point-min))
  (while (search-forward "<" nil t) (replace-match "&lt;"))

  (goto-char (point-min))
  (while (search-forward ">" nil t) (replace-match "&gt;"))

  ;; escape JavaScript
  (goto-char (point-min))
  (while (search-forward "\"" nil t) (replace-match "&quote;"))

  (goto-char (point-min))
  (while (search-forward "\\" nil t) (replace-match "⧷"))

  ;; make it js hash
  (goto-char (point-min))
  (while (search-forward "〈〈" nil t) (replace-match "\""))

  (goto-char (point-min))
  (while (search-forward "〉〉" nil t) (replace-match "\""))

  (goto-char (point-min))
  (while (search-forward "•85170" nil t) (replace-match ",\n"))
  )

;; (setq uuu (replace-regexp-in-string "\n" "•" uuu "FIXEDCASE" "LITERAL") )
;; (setq uuu (replace-regexp-in-string "<" "&lt;" uuu "FIXEDCASE" "LITERAL") )
;; (setq uuu (replace-regexp-in-string ">" "&gt;" uuu "FIXEDCASE" "LITERAL") )
;; (setq uuu (replace-regexp-in-string "&" "&amp;;" uuu "FIXEDCASE" "LITERAL") )

;; < > & needs to be encoded as HTML entities
;; " needs to be escaped
