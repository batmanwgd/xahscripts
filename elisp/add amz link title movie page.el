;; -*- coding: utf-8 -*-
;; 2010-11-03
;; add 「title="product title"」 to amazon links on a html page.

;; rough steps:
;; find amazon link of the form
;; <a class="amz" href="http://www.amazon.com/dp/B000055Y0X/?tag=xahh-20">amazon</a>

;; find a Wikipedia link above it, of this form
;; <a href="http://en.wikipedia.org/wiki/Dr._Strangelove">Dr. Strangelove</a>
;; extract the movie title

;; insert the attribute
;; title="…"
;; into the amazon link. Like this
;; <a class="amz" href="http://www.amazon.com/dp/B000055Y0X/?tag=xahh-20" title="Dr. Strangelove; movie">amazon</a>

(setq outputBuffer "*xah output*" )
(with-output-to-temp-buffer outputBuffer 

  (find-file "~/web/xahlee_org/Periodic_dosage_dir/skina/nelci_skina.html" )
  (goto-char 1)

  (while 
      (search-forward-regexp "<a class=\"amz\" href=\"http://www.amazon.com/dp/[^\"]+?\">amazon</a>"  nil t)

    (progn 
      ;; set points for amazon link
      (backward-char 11)
      (setq amzLinkInsertPoint (point) )

      ;; get title from preceding Wikipedia link
      (search-backward-regexp "<a href=\"http://...wikipedia.org/wiki/[^\"]+?\">\\([^<]+?\\)</a>")
      (setq titleText (match-string 1 ) )

      (when (yes-or-no-p titleText) 
        (goto-char amzLinkInsertPoint)
        (insert (concat " title=\"" titleText "; movie\"")) )
      )

    (progn (print "not found"))
    )
  
  (princ "Done deal!")
  )

