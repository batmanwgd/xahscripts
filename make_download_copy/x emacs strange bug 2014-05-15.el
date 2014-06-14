;; xah-remove-ads-in-file: Wrong type argument: integer-or-marker-p, nil

    ;; 179:<p><a href="">Screen Size Comparison: DVD, iPhone, iPad, MacBook, Blu-ray</a></p>


(xah-remove-ads-in-file
"/home/xah/web/xahlee_org/diklo/xahlee_info/comp/blog_past_2011-11.html"
"/home/xah/web/xahlee_info/comp/blog_past_2011-11.html"
"/home/xah/web/xahlee_info/"
)

(defun xah-remove-ads-in-file (fPath originalFilePath webRoot)
  "Modify the HTML file at fPath, to make it ready for download bundle.

This function change local links to “http://” links, Delete the google javascript snippet, and other small changes, so that the file is nicer to be viewed off-line at some computer without the entire xahlee.org's web dir structure.

The google javascript is the Google Analytics webbug that tracks web stat to xahlee.org.

fPath is the full path to the html file that will be processed.
originalFilePath is full path to the “same” file in the original web structure.
originalFilePath is used to construct new relative links."
  (let ( bds p1 p2 hrefValue default-directory
             (case-fold-search nil)
             )

    (with-temp-file fPath
      (insert-file-contents fPath)
      (goto-char 1)

      ;; (xahsite-remove-ads (point-min) (point-max))

      ;; go thru each link, if the link is local, then check if the file exist. if not, replace the link with proper http://xahlee.org/ url
      (goto-char 1)
      (while (search-forward-regexp "<a href=\"" nil t)

        (forward-char 1)
        (setq bds (bounds-of-thing-at-point 'filename))
        (setq p1 (car bds))
        (setq p2 (cdr bds))
        (setq hrefValue (buffer-substring-no-properties p1 p2))

        (when (xahsite-local-link-p hrefValue)
          (setq default-directory (file-name-directory fPath) )
          (when (not (file-exists-p (elt (split-uri-hashmark hrefValue) 0)))
            (delete-region p1 p2)
            (insert
             ;; (xahsite-filepath-to-href-value (xahsite-href-value-to-filepath hrefValue originalFilePath) originalFilePath)
             (xah-get-full-url originalFilePath hrefValue webRoot (xahsite-get-domain-of-local-file-path originalFilePath))
)
)))

      (goto-char 1)
      (while (search-forward-regexp "<img src[[:blank:]]*=[[:blank:]]*" nil t)
        (forward-char 1)
        (setq bds (bounds-of-thing-at-point 'filename))
        (setq p1 (car bds))
        (setq p2 (cdr bds))
        (setq hrefValue (buffer-substring-no-properties p1 p2))

        (when (xahsite-local-link-p hrefValue)
          (setq default-directory (file-name-directory fPath) )
          (when (not (file-exists-p hrefValue))
            (delete-region p1 p2)
            (insert (xah-get-full-url originalFilePath hrefValue webRoot (xahsite-get-domain-of-local-file-path originalFilePath)))
            )))
      ) ))
