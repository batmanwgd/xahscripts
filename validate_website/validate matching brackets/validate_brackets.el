;; -*- coding: utf-8 -*-
;; 2011-07-15
;; go thru a file, check if all brackets are properly matched.
;; e.g. good: (…{…}… “…”…)
;; bad: ( [)]
;; bad: ( ( )

(setq inputFile "xx_test_file.txt" ) ; a test file.

(setq inputDir "~/web/xahlee_org/") ; must end in slash
(setq inputDir "~/web/xahlee_info/") ; must end in slash

(setq ξbracketMatchList '())

;; (if argv
;;     (file-exists-p)
;; (setq inputDir (elt argv 0))

;; )

(defvar matchPairs '() "a alist. For each pair, the car is opening char, cdr is closing char.")
(setq matchPairs '(
                   ("“" . "”")
                   ("‹" . "›")
                   ("«" . "»")
                   ("【" . "】")
                   ("〖" . "〗")
                   ("〈" . "〉")
                   ("《" . "》")
                   ("「" . "」")
                   ("『" . "』")
                   ;; ("{" . "}")
                   ;; ("[" . "]")
                   ;; ("(" . ")")
                   )
      )

(defvar searchRegex "" "regex string of all pairs to search.")
(setq searchRegex "")
(mapc
 (lambda (mypair) ""
   (setq searchRegex (concat searchRegex (regexp-quote (car mypair)) "|" (regexp-quote (cdr mypair)) "|") )
   )
 matchPairs)

(setq searchRegex (substring searchRegex 0 -1)) ; remove the ending “|”

(setq searchRegex (replace-regexp-in-string "|" "\\|" searchRegex t t)) ; change | to \\| for regex “or” operation

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

(defun my-process-file (fpath)
  "process the file at fullpath fpath …"
  (let (myBuffer myStack ξchar ξpos)

    (setq myStack '() ) ; each entry is a vector [char position]
    (setq ξchar "") ; the current char found

    (when t
      ;; (not (string-match "/xx" fpath)) ; in case you want to skip certain files

      (setq myBuffer (get-buffer-create " myTemp"))
      (set-buffer myBuffer)
      (insert-file-contents fpath nil nil nil t)

      (goto-char 1)
      (while (search-forward-regexp searchRegex nil t)
        (setq ξpos (point)  )
        (setq ξchar (buffer-substring-no-properties ξpos (- ξpos 1))  )

        ;; (princ (format "-----------------------------\nfound char: %s\n" ξchar) )

        (let ((isClosingCharQ nil) (matchedOpeningChar nil) )
          (setq isClosingCharQ (rassoc ξchar matchPairs))
          (when isClosingCharQ (setq matchedOpeningChar (car isClosingCharQ) ) )

          ;; (princ (format "isClosingCharQ is: %s\n" isClosingCharQ) )
          ;; (princ (format "matchedOpeningChar is: %s\n" matchedOpeningChar) )

          (if
              (and
               (car myStack) ; not empty
               (equal (elt (car myStack) 0) matchedOpeningChar )
               )
              (progn
                ;; (princ (format "matched this top item on stack: %s\n" (car myStack)) )
                (setq myStack (cdr myStack) )
                )
            (progn
              ;; (princ (format "did not match this top item on stack: %s\n" (car myStack)) )
              (setq myStack (cons (vector ξchar ξpos fpath) myStack) ) )
            )
          )
        ;; (princ "current stack: " )
        ;; (princ myStack )
        ;; (terpri )
        )

      (when (not (equal myStack nil))
        (setq ξbracketMatchList (cons myStack ξbracketMatchList) )

        ;; (princ "Error file: ")
        ;; (princ fpath)
        ;; (print (car myStack) )
        )
      (kill-buffer myBuffer)
      )
    ))

(require 'find-lisp)

(let (outputBuffer)
  (setq outputBuffer "*xah match pair output*" )
  (with-output-to-temp-buffer outputBuffer
    ;; (my-process-file inputFile) ; use this to test one one single file
    (mapc 'my-process-file (find-lisp-find-files inputDir "\\.html$")) ; do all html files
    (princ "Done deal!")
    )
  )


(let ((outputBuffer "*xah bracket match report*"))
  (get-buffer-create outputBuffer)
  (set-buffer outputBuffer)
  (erase-buffer)
  (mapc
   (lambda ( ξerrorsPerFile)
     (mapc
      (lambda (ξerrorList)
        (let (
              (ξglyph (elt ξerrorList 0))
              (ξpos (elt ξerrorList 1))
              (ξfpath (elt ξerrorList 2))
              )
             (insert ξglyph " ")
             (insert-text-button (number-to-string ξpos)
                                 'mouse-face 'highlight
                                 'help-echo "mouse-2: visit this file in other window"
                                 'keymap (let ((ξkmap (make-sparse-keymap)))
                                           (define-key ξkmap [mouse-1] 'my-operate-button)
                                           (define-key ξkmap (kbd "<return>") 'my-operate-button)
                                           ξkmap)
                                 'myglyph ξglyph 
                                 'mypos ξpos
                                 'fpath ξfpath
                                 )
             (insert " " ξfpath "\n")
          )
             )
      ξerrorsPerFile
           )
     (insert "\n")
     )
  ξbracketMatchList)
(insert "Done")
  (switch-to-buffer outputBuffer)
  )
