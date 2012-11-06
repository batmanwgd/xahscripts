;; 2011-10-01

ooooooooooo


(defun my-operate-button (ξevent)
  ""
  (interactive "e")
  (let ((ξwindow (posn-window (event-end ξevent)))
        (ξpos (posn-point (event-end ξevent)))
        ξfile
        fpath ; get file path from properties
        mypos ; get pos from properties
        )
    (setq fpath (get-text-property ξpos 'fpath))
    (setq mypos (get-text-property ξpos 'mypos))

    (find-file-other-window fpath)
    (goto-char mypos)
    ))




(add-text-properties 17 28
 '(mouse-face highlight help-echo "mouse-2: visit this file in other window"))

λ
;; how to make a link

;; ① indicating clickability when the mouse moves over the link
;; ② making RET or Mouse-2 on that link do something
;; ③ setting up a follow-link condition so that the link obeys mouse-1-click-follows-link.


(insert-text-button "〖“ 28979〗" 

                    'mouse-face 'highlight
                    'help-echo "mouse-2: visit this file in other window"
                    'keymap (let ((ξkmap (make-sparse-keymap)))
                             (define-key ξkmap [mouse-1] 'my-operate-button)
                             ξkmap)
'fpath "c:/Users/h3/web/xxst/elisp/validate matching brackets/validate_brackets.el"
'mypos 2475
)

〖“ 28979〗



: insert-text-button label &rest properties

(text-properties-at 1)

(put-text-property 28 50 'face 'font-lock-comment-delimiter-face )
(put-text-property 28 50 'fontified t )

(add-text-properties 28 50
                     '(mouse-face highlight
                                  help-echo "mouse-2: visit this file in other window"))


;; remove property
(remove-text-properties 1 (point-max) '(face nil))
(remove-list-of-text-properties 1 (point-max) '(face))

(make-text-button beg end '(action ))


(let ((map (make-sparse-keymap)))
  (define-key map [mouse-2] 'operate-this-button)
  (put-text-property link-start link-end 'keymap map))

(face font-lock-comment-delimiter-face fontified t)



(if (dired-move-to-filename)
          (add-text-properties
            (point)
            (save-excursion
              (dired-move-to-end-of-filename)
              (point))
            '(mouse-face highlight
              help-echo "mouse-2: visit this file in other window")))

(defun dired-mouse-find-file-other-window (event)
  "In Dired, visit the file or directory name you click on."
  (interactive "e")
  (let ((window (posn-window (event-end event)))
        (pos (posn-point (event-end event)))
        file)
    (if (not (windowp window))
        (error "No file chosen"))
    (with-current-buffer (window-buffer window)
      (goto-char pos)
      (setq file (dired-get-file-for-visit)))
    (if (file-directory-p file)
        (or (and (cdr dired-subdir-alist)
                 (dired-goto-subdir file))
            (progn
              (select-window window)
              (dired-other-window file)))
      (select-window window)
      (find-file-other-window (file-name-sans-versions file t)))))


(let ((map (make-sparse-keymap)))
  (define-key map [mouse-2] 'operate-this-button)
  (put-text-property link-start link-end 'keymap map))
