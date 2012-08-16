;; -*- coding: utf-8 -*-
;; 2011-07-03
;; replace image tags to use html5's “figure”  and “figcaption” tags.
;;
;; Example. This:
;; <div class="img">…</div>
;; should become this
;; <figure>…</figure>
;;
;; do this for all files in a dir.

;; the code may be changed so that this
;; 「<div class="obj">…</div>」
;; also get changed to the “figure” tag

;; rough steps:
;; find the <div class="img">
;; use sgml-skip-tag-forward to move to the ending tag.
;; save their positions.

(setq inputDir "~/web/xahlee_org/" ) ; dir should end with a slash

(defun my-process-file (fPath)
  "Process the file at FPATH …"
  (let (myBuff p1 p2 p3 p4 (ξi 0) (changedItems '()) sStr)
    
    (setq myBuff (find-file fPath))

    (widen)
    (goto-char 1) ;; in case buffer already open

    ;; (setq sStr "<p class=\"cpt\">")
    (setq sStr "<div class=\"obj\">" )
    ;; (setq sStr "<div class=\"img\">" )

    (while
        (search-forward sStr nil t)

      (progn
        (setq p2 (point) )              ; end of 「<div class="obj">」
        (search-backward "<" )
        (setq p1 (point) )              ; start of 「<div class="obj">」

        (forward-char 1)
        (sgml-skip-tag-forward 1)
        (setq p4 (point) )              ; end of 「</div>」
        (search-backward "<" )
        (setq p3 (point) )              ; start of of 「</div>」

        ;; (narrow-to-region p1 p4)
        ;; (goto-char (point-min))

        (when t
          ;; (y-or-n-p "replace?")
          (progn
            (setq ξi (1+ ξi))
            (setq changedItems (cons (buffer-substring-no-properties p1 p4) changedItems ) )
            ;; (princ (buffer-substring-no-properties p1 p4)) (princ "\n")

            (delete-region p3 p4 )
            (goto-char p3)
            (if (string-match "cpt" sStr)
                (insert "</figcaption>")
              (insert "</figure>")
              )

            (delete-region p1 p2 )
            (goto-char p1)
            (if (string-match "cpt" sStr)
                (insert "<figcaption>")
              (insert "<figure>")
              )
            ;; (widen)

) ) ) )

    (when (not (= ξi 0))
      (princ "-------------------------------------------\n")
      (princ (format "%d %s\n\n" ξi fPath))

      (mapc (lambda (ξx) (princ (format "%s\n\n" ξx)) ) changedItems)
      )

    (when (not (buffer-modified-p myBuff)) (kill-buffer myBuff) )

    ) )

(require 'find-lisp)


(global-font-lock-mode 0)

(let (outputBuffer)
  (setq outputBuffer "*xah img/figure replace output*" )
  (with-output-to-temp-buffer outputBuffer
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )

(global-font-lock-mode 1)
