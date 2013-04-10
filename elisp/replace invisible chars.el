;-*- coding: utf-8 -*-
;〈Annoying Invisible ZERO WIDTH NO-BREAK SPACE Character from Google Plus, Twitter〉
; http://xahlee.info/comp/invisible_BOM_char_from_Google_site.html

; replace-BOM-mark-etc

; show
(xah-find-replace-text-regex "\u200f\\|\ufeff" "" "~/web/ergoemacs_org/emacs/" "\\.html$" nil nil t)

; replace
(xah-find-replace-text-regex "\u200f\\|\ufeff" "" "~/web/ergoemacs_org/emacs/" "\\.html$" t nil t)

;; count ZERO WIDTH NO-BREAK SPACE
(xah-find-count (char-to-string 65279) ">" "0" "~/web/" "\\.html$")

;; list text that contains ZERO WIDTH NO-BREAK SPACE
(xah-find-text (char-to-string 65279) "~/web/" "\\.html$")

;; remove ZERO WIDTH NO-BREAK SPACE (Unicode #65279)
;(xah-find-replace-text (char-to-string 65279) "" "~/web/" "\\.html$")


;; count RIGHT-TO-LEFT MARK

(xah-find-replace-text (char-to-string 8207) "8cxcx" "~/web/" "\\.html$")

;; count RIGHT-TO-LEFT MARK
(xah-find-count (char-to-string 8207) ">" "0" "~/web/" "\\.html$")
(xah-find-count "\u200f" ">" "0" "~/web/ergoemacs_org/emacs/" "\\.html$")
