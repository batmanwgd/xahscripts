;; -*- coding: utf-8; lexical-binding: t; -*-

(require 'find-lisp)

(require 'xah-html-mode)

;; issues

;; go thru xah emacs tutorial, for every html page, redo the htmlize syntax coloring.
;; also

;; arbitrary class name that's not recognized langCode
;; <pre class="modeline">‹buffer name›   ‹major mode name›   ‹line num›   ‹modified status›</pre>
;; eg at
;; /home/xah/web/ergoemacs_org/emacs/modernization_mode_line.html

;; lang mode may not be installed or loaded
;; tuarag mode, not loaded

;; (xah-find-replace-text ">search-forward-regexp</span>" ">re-search-forward</span>" "/home/xah/web/ergoemacs_org/emacs/" "\\.html\\'" t t t t)

;; (xah-find-replace-text ">search-forward-regexp</span>" ">re-search-forward</span>" "/home/xah/web/ergoemacs_org/misc/" "\\.html\\'" t t t t)

(defun xah-redo-site-htmlize (*filePaths)
  "redo all htmlize syntax coloring on xah sites
Version 2017-01-12"
  (with-output-to-temp-buffer "*xah out*"
    (mapc
     (lambda (x)
       (princ x)
       (let ( -result )
         (setq -result (xah-html-redo-syntax-coloring-file x))
         (print -result))
       (terpri))
     *filePaths
     )))

;; (xah-html-redo-syntax-coloring-file "/home/xah/web/ergoemacs_org/emacs/elisp_curly-quotes-to-emacs-function-tag.html")

(setq filePaths1 (find-lisp-find-files "/home/xah/web/ergoemacs_org/emacs/" "\\.html$" ))

(setq filePaths2 (find-lisp-find-files "/home/xah/web/ergoemacs_org/misc/" "\\.html$" ))


;; get a list of all files containing elisp code
;; (xah-find-text "<pre class=\"emacs-lisp\">" "/home/xah/web/xahlee_info/" "\\.html\\'" nil t)

(setq filePaths3 '(
"/home/xah/web/xahlee_info/mswin/emacs_autohotkey_mode.html"
"/home/xah/web/xahlee_info/kbd/banish_shift_key.html"
"/home/xah/web/xahlee_info/kbd/creating_apl_keyboard_layout.html"
"/home/xah/web/xahlee_info/kbd/Truly_Ergonomic_keyboard_layout.html"
"/home/xah/web/xahlee_info/perl-python/what_is_expresiveness.html"
"/home/xah/web/xahlee_info/perl-python/python_construct_tree_from_edge.html"
"/home/xah/web/xahlee_info/js/google-code-prettify/emacs_elisp.html"
"/home/xah/web/xahlee_info/3d/povray_emacs.html"
"/home/xah/web/xahlee_info/UnixResource_dir/writ2/programer_styles_and_tack.html"
"/home/xah/web/xahlee_info/UnixResource_dir/writ/unix_copy_dir.html"
"/home/xah/web/xahlee_info/UnixResource_dir/writ/lisp_problems_by_ruby.html"
"/home/xah/web/xahlee_info/UnixResource_dir/writ/camelCase_code_formatting.html"
"/home/xah/web/xahlee_info/UnixResource_dir/writ/currying.html"
"/home/xah/web/xahlee_info/UnixResource_dir/writ/mac_emacs_unicode.html"
"/home/xah/web/xahlee_info/UnixResource_dir/writ/notations.html"
"/home/xah/web/xahlee_info/UnixResource_dir/writ/notations_mma.html"
"/home/xah/web/xahlee_info/racket/racket_emacs_racket-mode.html"
"/home/xah/web/xahlee_info/python/python3_map_with_side_effect.html"
"/home/xah/web/xahlee_info/comp/lisp_read-from-minibuffer_propels_deep_questions.html"
"/home/xah/web/xahlee_info/comp/validate_matching_brackets.html"
"/home/xah/web/xahlee_info/comp/python_vs_elisp_docstring_convention.html"
"/home/xah/web/xahlee_info/comp/xml_nested_syntax_vs_lisp.html"
"/home/xah/web/xahlee_info/comp/html6.html"
"/home/xah/web/xahlee_info/comp/ctags_etags_gtags.html"
"/home/xah/web/xahlee_info/comp/oop.html"
"/home/xah/web/xahlee_info/comp/programing_or_considered_harmful.html"
"/home/xah/web/xahlee_info/comp/design_math_symbol_input.html"
"/home/xah/web/xahlee_info/comp/unicode_support_ruby_python_elisp.html"
"/home/xah/web/xahlee_info/comp/strings_syntax_in_lang.html"
"/home/xah/web/xahlee_info/comp/xx_comp_blog.html"
"/home/xah/web/xahlee_info/comp/whitespace_in_programing_language.html"
"/home/xah/web/xahlee_info/comp/blog_past_2014-07.html"
"/home/xah/web/xahlee_info/comp/programing_variable_naming.html"
"/home/xah/web/xahlee_info/comp/lisp_syntax_function_pipe.html"
"/home/xah/web/xahlee_info/comp/in-place_algorithm.html"
"/home/xah/web/xahlee_info/comp/unix_zip_problem.html"
"/home/xah/web/xahlee_info/comp/parallel_programing_exercise_asciify-string.html"
"/home/xah/web/xahlee_info/comp/Luhn_algorithm.html"
"/home/xah/web/xahlee_info/comp/programing_decimalize_latitude_longitude.html"
"/home/xah/web/xahlee_info/comp/why_lisp_macro_sucks.html"
"/home/xah/web/xahlee_info/comp/Mathematica_vs_lisp_syntax.html"

))

(xah-redo-site-htmlize filePaths1)

(xah-redo-site-htmlize filePaths2)

(xah-redo-site-htmlize filePaths3)
