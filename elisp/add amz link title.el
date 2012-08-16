;; -*- coding: utf-8 -*-
;; 2010-11-03
;; add 「title="product title"」 to amazon links on my site.

;; INCOMPLETE

;; for each html page,
;; find amazon link of the form
;; 「<a class="amz" href="http://www.amazon.com/dp/0792838068/?tag=xahh-20">amazon</a>」

;; find in the same line for 〈title〉 or 《title》 or “title”
;; add to the link this
;; add title="title"

(setq inputDir "~/web/xahlee_org/Periodic_dosage_dir/sanga_pemci/" ) ; dir must end with a slash

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (amzLinkInsertPoint titleText didFindQ lineBegin)

    (when t

      (setq didFindQ nil )
      (find-file fPath )
      (goto-char 1)

      (while 
          (search-forward-regexp "<a class=\"amz\" href=\"http://www.amazon.com/dp/[^\"]+?\">amazon</a>"  nil t)
        (print fPath)

        (progn 
          ;; set points for amazon link
          (backward-char 11)
          (setq amzLinkInsertPoint (point) )
          (setq lineBegin (line-beginning-position) )

          ;; get title 
          (when
              ;; (search-backward-regexp "《\\([^》]+?\\)》" lineBegin t)
              (search-backward-regexp "〈\\([^〉]+?\\)〉" lineBegin t)
            (setq titleText (match-string 1 ) )

            (if (y-or-n-p titleText) 
                (progn
                  (setq didFindQ t )
                  (goto-char amzLinkInsertPoint)
                  (insert (concat " title=\"" titleText "; movie\"")) 
                  (print titleText)
                  )
              (goto-char amzLinkInsertPoint)
              ) ) ) )

      (when (not didFindQ) (kill-buffer ))

      )
    ))

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*amz link fix output*" )
  (with-output-to-temp-buffer outputBuffer 
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )


