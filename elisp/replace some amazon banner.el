; -*- coding: utf-8 -*-
;; 2011-01-12

;; give a dir
;; for all html files in the dir
;; replace some amazon banner by another.
;; the “some” is decided by a random number

(setq inputDir "~/web/xahlee_org/" ) ; dir should end with a slash

(setq amzBanner1 "<div class=\"amzo\"><OBJECT classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" codebase=\"http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab\" id=\"Player_38563c63-d564-466b-b245-ef8a99b5a550\"  WIDTH=\"160px\" HEIGHT=\"400px\"> <PARAM NAME=\"movie\" VALUE=\"http://ws.amazon.com/widgets/q?ServiceVersion=20070822&MarketPlace=US&ID=V20070822%2FUS%2Fxahhome-20%2F8009%2F38563c63-d564-466b-b245-ef8a99b5a550&Operation=GetDisplayTemplate\"><PARAM NAME=\"quality\" VALUE=\"high\"><PARAM NAME=\"bgcolor\" VALUE=\"#FFFFFF\"><PARAM NAME=\"allowscriptaccess\" VALUE=\"always\"><embed src=\"http://ws.amazon.com/widgets/q?ServiceVersion=20070822&MarketPlace=US&ID=V20070822%2FUS%2Fxahhome-20%2F8009%2F38563c63-d564-466b-b245-ef8a99b5a550&Operation=GetDisplayTemplate\" id=\"Player_38563c63-d564-466b-b245-ef8a99b5a550\" quality=\"high\" bgcolor=\"#ffffff\" name=\"Player_38563c63-d564-466b-b245-ef8a99b5a550\" allowscriptaccess=\"always\"  type=\"application/x-shockwave-flash\" align=\"middle\" height=\"400px\" width=\"160px\"></embed></OBJECT> <NOSCRIPT><A HREF=\"http://ws.amazon.com/widgets/q?ServiceVersion=20070822&MarketPlace=US&ID=V20070822%2FUS%2Fxahhome-20%2F8009%2F38563c63-d564-466b-b245-ef8a99b5a550&Operation=NoScript\">Amazon.com Widgets</A></NOSCRIPT></div>" )

(setq amzBanner2 "<div class=\"amzb\"><iframe src=\"http://rcm.amazon.com/e/cm?t=xahhome-20&o=1&p=11&l=ur1&category=textbooks&banner=17P1AE8RQ1T7ZFC62V82&f=ifr\" width=\"120\" height=\"600\" scrolling=\"no\" border=\"0\" marginwidth=\"0\" style=\"border:none;\" frameborder=\"0\"></iframe></div>" )

; functions

; open a file, process it
(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (p1 p2 myBuffer )

    (when (> (random 100) 60)
        ;; (and (not (string-match "/xx" fPath)))

      ;; (font-lock-mode -1)
      (setq myBuffer (find-file fPath) )

      (goto-char 1)
      (when (search-forward amzBanner1 nil t)

        (setq p2 (point) )
        (setq p1 (line-beginning-position) )

        (insert amzBanner2)
        (delete-region p1 p2 )
        )

      (copy-file fPath (concat fPath "~bk~" ) t) ;backup file
      (save-buffer myBuffer )
      (kill-buffer myBuffer)
      )
    ))


; main
(desktop-save-mode 0)

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*xah ad chitika ads output*" )
  (with-output-to-temp-buffer outputBuffer 
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )

(desktop-save-mode 1)
