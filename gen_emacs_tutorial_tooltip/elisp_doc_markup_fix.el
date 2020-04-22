;; 2016-12-27

(xah-find-replace-text-regex
"Special Form: <strong>\\([^<]+?\\)</strong>"
"Special Form: <code class=\"elisp-special-form\">\\1</code>"
"/home/xah/web/ergoemacs_org/emacs_manual/elisp/"
"\\.html\\'" t t t)

(xah-find-replace-text-regex
"Macro: <strong>\\([^<]+?\\)</strong>"
"Macro: <code class=\"elisp-macro\">\\1</code>"
"/home/xah/web/ergoemacs_org/emacs_manual/elisp/"
"\\.html\\'" t t t)

(xah-find-replace-text-regex
"Command: <strong>\\([^<]+?\\)</strong>"
"Command: <code class=\"elisp-command\">\\1</code>"
"/home/xah/web/ergoemacs_org/emacs_manual/elisp/"
"\\.html\\'" t t t)

(xah-find-replace-text-regex
"Prefix Command: <strong>\\([^<]+?\\)</strong>"
"Prefix Command: <code class=\"elisp-prefix-command\">\\1</code>"
"/home/xah/web/ergoemacs_org/emacs_manual/elisp/"
"\\.html\\'" t t t)

(xah-find-replace-text-regex
"Function: <strong>\\([^<]+?\\)</strong>"
"Function: <code class=\"elisp-function\">\\1</code>"
"/home/xah/web/ergoemacs_org/emacs_manual/elisp/"
"\\.html\\'" t t t)

(xah-find-replace-text-regex
"User Option: <strong>\\([^<]+?\\)</strong>"
"User Option: <var class=\"elisp-user-option\">\\1</var>"
"/home/xah/web/ergoemacs_org/emacs_manual/elisp/"
"\\.html\\'" t t t)

(xah-find-replace-text-regex
"Variable: <strong>\\([^<]+?\\)</strong>"
"Variable: <var class=\"elisp-variable\">\\1</var>"
"/home/xah/web/ergoemacs_org/emacs_manual/elisp/"
"\\.html\\'" t t t)

(xah-find-replace-text-regex
"Constant: <strong>\\([^<]+?\\)</strong>"
"Constant: <var class=\"elisp-constant\">\\1</var>"
"/home/xah/web/ergoemacs_org/emacs_manual/elisp/"
"\\.html\\'" t t t)

