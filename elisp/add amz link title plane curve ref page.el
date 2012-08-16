;; -*- coding: utf-8 -*-
;; 2010-11-18
;; add 「title="product title"」 to amazon links on a html page.

;; rough steps:
;; find amazon link of the form
;; <a class="amz" href="http://www.amazon.com/dp/B000055Y0X/?tag=xahh-20" title="xx">amazon</a>

;; find “title” in the same line
;; extract the movie title

;; insert the attribute
;; title="…"
;; into the amazon link. Like this
;; <a class="amz" href="http://www.amazon.com/dp/B000055Y0X/?tag=xahh-20" title="Dr. Strangelove; movie">amazon</a>

(setq outputBuffer "*xah output*" )
(with-output-to-temp-buffer outputBuffer 

  (find-file "~/web/xahlee_org/Wallpaper_dir/c6_RelatedWebSites.html" )
  (goto-char 1)

  (while 
      (search-forward-regexp "<a class=\"amz\" href=\"http://www.amazon.com/dp/........../\\?tag=xahh-20\" title=\"xx\">amazon</a>"  nil t)

    (progn 
      ;; set points for amazon link
      (backward-char 11)
      (setq amzLinkInsertPoint (point) )

       ;; get title from preceding bracket
;;       (search-backward-regexp "《\([ -_A-Za-z]+\)》")
     (search-backward-regexp "《\\([^》]+?\\)》")
       (setq titleText (match-string 1 ) )

      (when (yes-or-no-p titleText) 
        (goto-char amzLinkInsertPoint)
        (insert (concat " title=\"" titleText "; book\"")) 
)

      )

    (progn (print "not found"))
    )
  
  (princ "Done deal!")
  )

