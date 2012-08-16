;; -*- coding: utf-8 -*-
;; 2011-01-10
;; add chitika ad code to my site.

;; basically, if the page has many “p” tags, add it, else don't.

(setq inputDir "~/web/xahlee_org/" )

(setq chitikaBanner "<div class=\"chtk\"><script type=\"text/javascript\">ch_client=\"polyglut\";ch_width=550;ch_height=90;ch_type=\"mpu\";ch_sid=\"Chitika Default\";ch_backfill=1;ch_color_site_link=\"#00C\";ch_color_title=\"#00C\";ch_color_border=\"#FFF\";ch_color_text=\"#000\";ch_color_bg=\"#FFF\";</script><script src=\"http://scripts.chitika.net/eminimalls/amm.js\" type=\"text/javascript\"></script></div>" )

;; generate a list of files
;; visite each. Say, current file is ff
;; count number of <p> in ff. Say, that's n. If n > 5, then add to before n/2.


(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (myBuffer (tagCount_p 0) (cnt_chitikaBanner 0) )

    (when t
        ;; (and (not (string-match "/xx" fPath)))

      (setq myBuffer (get-buffer-create " myTemp"))
      (set-buffer myBuffer)
      (insert-file-contents fPath nil nil nil t)

      (goto-char 1)
      (while (search-forward "<p>" nil t)
        (setq tagCount_p (1+ tagCount_p))
        )

      (goto-char 1)
      (while (search-forward chitikaBanner nil t)
        (setq cnt_chitikaBanner (1+ cnt_chitikaBanner))
        )

      (when
          (and (>= tagCount_p 5)
              (= cnt_chitikaBanner 0)
              )

          (progn 
            ;; move to the 5th <p> tag
            (goto-char 1)
            (dotimes (ii 4 ) 
              (search-forward "<p>" nil t)
              )

            (backward-char 3)
            (insert adBannerStr "\n\n")

            (copy-file fPath (concat fPath "~bk~" ) t) ;backup file
            (write-file fPath)
            (princ (format "changed: %s\n"  fPath))
            )
        )

      (kill-buffer myBuffer)
      )
    ))

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*xah ad chitika ads output*" )
  (with-output-to-temp-buffer outputBuffer 
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )
