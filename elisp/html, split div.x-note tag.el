;; -*- coding: utf-8 -*-
;; 2011-08-13
;; process all html files in a dir.
;; split any markup like this:
;; <div class="x-note">… • … • …</div>
;; by the bullet •
;; into several x-note tags

(setq inputDir "~/web/xahlee_org/" )

;; add a ending slash if not there
(when (not (string= "/" (substring inputDir -1) )) (setq inputDir (concat inputDir "/") ) )

;; files to process
(setq fileList 
[
"~/web/xahlee_org/Periodic_dosage_dir/_p2/why_not_christian.html"
"~/web/xahlee_org/music/young_americans.html"
"~/web/xahlee_org/emacs/elisp_text_processing_split_annotation.html"
]
)

(defun my-process-file-xnote (fPath)
  "Process the file at FPATH …"
  (let (myBuffer (ξi 0) p1 p2 ξmeat
                 ξmeatNew
                 (changedItems '())
                 (tagBegin "<div class=\"x-note\">" )
                 (tagEnd "</div>" )
                 )

    (require 'sgml-mode)
    (when t

      (setq myBuffer (find-file fPath))
      (goto-char 1)
      (while (search-forward "<div class=\"x-note\">" nil t)

        ;; capture the x-note tag text
        (setq p1 (point))
        (backward-char 1)
        (sgml-skip-tag-forward 1)
        (backward-char 6)
        (setq p2 (point))
        (setq ξmeat (buffer-substring-no-properties p1 p2))

        ;; if it contains a bullet
        (when (string-match "•" ξmeat)
          (setq ξi (1+ ξi))

          ;; clean the text. Remove some newline and <br> that's no longer needed
          (setq ξmeat (replace-regexp-in-string "\n*• *" "•" ξmeat t t ) )
          (setq ξmeat (replace-regexp-in-string "\n$" "" ξmeat t t ) ) ; delete ending eol
          (setq ξmeat (replace-regexp-in-string "<br>•" "•" ξmeat t t ) )

          ;; put the new entries into a list, for later reporting
          (setq changedItems (split-string ξmeat  "•" t) )

          ;; break the bullet into new end/begin tags
          (setq ξmeatNew (replace-regexp-in-string "•" (concat tagEnd "\n" tagBegin) ξmeat t t ) )

          (goto-char p1)
          (delete-region p1 p2)
          (insert ξmeatNew)

          ;; remove the newline before end tag
          (when (looking-back "\n") (delete-backward-char 1))
          )
        )

      ;; report if the occurance is not n times
      (when (not (= ξi 0))
          (princ "-------------------------------------------\n")
          (princ (format "%d %s\n\n" ξi fPath))

          (mapc (lambda (ξx) (princ (format "%s\n\n" ξx)) ) changedItems)
        )

        ;; close buffer if there's no change. Else leave it open.
        (when (not (buffer-modified-p myBuffer)) (kill-buffer myBuffer) )
      )
    ))

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*xah x-note output*" )
  (with-output-to-temp-buffer outputBuffer 
    ;; (mapc 'my-process-file-xnote fileList)
    (mapc 'my-process-file-xnote (find-lisp-find-files inputDir "\\.html$"))
  (princ "Done deal!")
    )
  )
