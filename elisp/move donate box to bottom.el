;; -*- coding: utf-8 -*-
;; 2010-08-25

;; move the donation box to the bottom of page
;; <div class="dnt0c7af">Was this page useful? If so, please do donate $3, <a href="http://xahlee.org/thanks.html">thank YOU!</a><form action="https://www.paypal.com/cgi-bin/webscr" method="post"><div><input type="hidden" name="cmd" value="_s-xclick"><input type="hidden" name="hosted_button_id" value="8127788"><input type="image" src="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" name="submit"><img alt="" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1"></div></form></div>

(setq inputDir "~/web/xahlee_org/" ) ; dir should end with a slash

(global-font-lock-mode 0)

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (p3 p4 hpos donateStr myBuff)

    ;; open the file
    ;; find the position of <div class="dnt0c7af">
    ;; find the pos of <h1>
    ;; if it is above, the delete it.
    ;; add it just above this <div class="ftr">

    (setq myBuff (find-file fPath ) )
    (goto-char 1) 
    (if 
        (search-forward "<div class=\"dnt0c7af\">"  nil t)

        (progn 
          (setq p3 (line-beginning-position) )
          (setq p4 (line-end-position) )
          (setq donateStr (buffer-substring p3 p4) )

          (goto-char 1) 
          (if 
              (search-forward "<h1>"  nil t)
              (setq hpos (line-beginning-position) )
            (if 
                (search-forward "<h2>"  nil t)
                (setq hpos (line-beginning-position) )
              (if 
                  (search-forward "<div class=\"nav\">"  nil t)
                  (setq hpos (line-beginning-position) )
                )
              )
            )

          (if (< p3 hpos)
              (progn
                (delete-region p3 p4 )
                (goto-char 1)
                (search-forward "<div class=\"ftr\"><div class=\"sig\">")
                (beginning-of-line)
                (insert donateStr "\n\n")
                ;; (save-buffer )
                )
            (progn (kill-buffer myBuff) "do nothing")
            )

          )

      (progn (kill-buffer myBuff) "do nothing")
      )

    ))

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*xah move donation box*" )
  (with-output-to-temp-buffer outputBuffer 
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )

(global-font-lock-mode 1)