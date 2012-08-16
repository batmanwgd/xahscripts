;; -*- coding: utf-8 -*-
;; 2011-03-22
;; add amazon ad if it's not there

;; Given a input dir
;; if the html page does not have a amazon ad
;; add it
 
(setq fileList 

[

]
 )

(setq adText "<div class=\"amz728x90\"><script type=\"text/javascript\"><!--
amazon_ad_tag = \"xahhome-20\"; amazon_ad_width = \"728\"; amazon_ad_height = \"90\"; amazon_ad_link_target = \"new\";//--></script><script type=\"text/javascript\" src=\"http://www.assoc-amazon.com/s/ads.js\"></script></div>")

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (hasAdQ )

    (find-file fPath )
    (goto-char 1)
    (setq hasAdQ (search-forward "<div class=\"amz728x90\"><script"  nil t) )

    (if hasAdQ
        (kill-buffer)
      (progn 
    (goto-char 1)

        (goto-char 1)
        (search-forward "<div id=\"disqus_thread\"></div>" )
        (backward-char 30)
        (insert adText "\n\n")
        (print fPath)
        ))
    ))

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*add amazon ad*" )
  (with-output-to-temp-buffer outputBuffer 
    (mapc 'my-process-file fileList)
    (princ "Done deal!")
    )
  )


