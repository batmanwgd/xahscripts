;; -*- coding: utf-8; lexical-binding: t; -*-
;; 2011-07-15
;; 2017-05-13

;; go thru a file, check if all brackets are properly matched.
;; e.g. good: (…{…}… “…”…)
;; bad: ( [)]
;; bad: ( ( )

(setq G_inputFile "xx_test_file.txt" ) ; a test file.

(setq G_inputDir "~/web/xahlee_org/") ; must end in slash
(setq G_inputDir "~/web/xahlee_info/") ; must end in slash
(setq G_inputDir "/home/xah/web/wordyenglish_com/alice/") ; must end in slash
(setq G_inputDir "/home/xah/web/xahlee_info/kbd/" ) ; must end in slash
(setq G_inputDir "/Users/xah/web/ergoemacs_org/emacs/" ) ; must end in slash



;; (if argv
;;     (file-exists-p)
;; (setq G_inputDir (elt argv 0))

;; )

(defvar G_brackets '() "a alist. For each pair, the car is opening char, cdr is closing char.")
(setq
 G_brackets
 '(
   ;; ("“" . "”")
   ;; ("‹" . "›")
   ;; ("«" . "»")
   ("【" . "】")
   ;; ("〖" . "〗")
   ;; ("〈" . "〉")
   ;; ("《" . "》")
   ;; ("「" . "」")
   ;; ("『" . "』")
   ;; ("{" . "}")
   ;; ("[" . "]")
   ;; ("(" . ")")
   ))

(defvar G_regex "" "regex string of all pairs to search.")

(setq G_regex (mapconcat (lambda (x) (concat (car x) "\\\\|" (cdr x))) G_brackets "\\\\|"))

;; (progn
;;   ;; generate G_regex from G_brackets
;;   (mapc
;;    (lambda (x) ""
;;      (setq G_regex (concat G_regex (regexp-quote (car x)) "|" (regexp-quote (cdr x)) "|")))
;;    G_brackets)
;;   ;; remove the ending “|”
;;   (setq G_regex (substring G_regex 0 -1))
;;   ;; change | to \\| for regex “or” operation
;;   (setq G_regex (replace-regexp-in-string "|" "\\|" G_regex t t)))

(setq $bracketMatchList '())

(defun my-operate-button ($event)
  ""
  (interactive "e")
  (let (($window (posn-window (event-end $event)))
        ($pos (posn-point (event-end $event)))
        $file
        @fpath ; get file path from properties
        mypos ; get pos from properties
        )
    (setq @fpath (get-text-property $pos '@fpath))
    (setq mypos (get-text-property $pos 'mypos))

    (find-file-other-window @fpath)
    (goto-char mypos)
    ))

(defun my-process-file (@fpath)
  "process the file at fullpath @fpath …"
  (let ($buffer $stack $char $pos)

    (setq $stack '()) ; each entry is a vector [char position]
    (setq $char "")   ; the current char found

    (when t
      ;; (not (string-match "/xx" @fpath)) ; in case you want to skip certain files

      (setq $buffer (get-buffer-create " myTemp"))
      (set-buffer $buffer)
      (insert-file-contents @fpath nil nil nil t)

      (goto-char 1)

      (while (re-search-forward G_regex nil t)
        (setq $pos (point))
        (setq $char (buffer-substring-no-properties $pos (- $pos 1)))

        ;; (princ (format "-----------------------------\nfound char: %s\n" $char) )

        (let (($isClosingCharQ nil) ($matchedOpeningChar nil))
          (setq $isClosingCharQ (rassoc $char G_brackets))
          (when $isClosingCharQ (setq $matchedOpeningChar (car $isClosingCharQ)))

          ;; (princ (format "$isClosingCharQ is: %s\n" $isClosingCharQ) )
          ;; (princ (format "$matchedOpeningChar is: %s\n" $matchedOpeningChar) )

          (if
              (and
               (car $stack) ; not empty
               (equal (elt (car $stack) 0) $matchedOpeningChar ))
              (progn
                ;; (princ (format "matched this top item on stack: %s\n" (car $stack)) )
                (setq $stack (cdr $stack)))
            (progn
              ;; (princ (format "did not match this top item on stack: %s\n" (car $stack)) )
              (setq $stack (cons (vector $char $pos @fpath) $stack)))))
        ;; (princ "current stack: " )
        ;; (princ $stack )
        ;; (terpri )
        )

      (when (not (equal $stack nil))
        (setq $bracketMatchList (cons $stack $bracketMatchList))

        ;; (princ "Error file: ")
        ;; (princ @fpath)
        ;; (print (car $stack) )
        )
      (kill-buffer $buffer))))

(let ($outputBuffer)
  (setq $outputBuffer "*xah match pair output*" )
  (with-output-to-temp-buffer $outputBuffer
    ;; (my-process-file G_inputFile) ; use this to test one one single file
    (mapc 'my-process-file (directory-files-recursively G_inputDir "\\.html$" ))
    (princ "Done deal!")))

;; (let (($outputBuffer "*xah bracket match report*"))
;;   (get-buffer-create $outputBuffer)
;;   (set-buffer $outputBuffer)
;;   (erase-buffer)
;;   (mapc
;;    (lambda ( $errorsPerFile)
;;      (mapc
;;       (lambda ($errorList)
;;         (let (
;;               ($glyph (elt $errorList 0))
;;               ($pos (elt $errorList 1))
;;               ($fpath (elt $errorList 2))
;;               )
;;              (insert $glyph " ")
;;              (insert-text-button (number-to-string $pos)
;;                                  'mouse-face 'highlight
;;                                  'help-echo "mouse-2: visit this file in other window"
;;                                  'keymap (let (($kmap (make-sparse-keymap)))
;;                                            (define-key $kmap [mouse-1] 'my-operate-button)
;;                                            (define-key $kmap (kbd "RET") 'my-operate-button)
;;                                            $kmap)
;;                                  'myglyph $glyph
;;                                  'mypos $pos
;;                                  'fpath $fpath
;;                                  )
;;              (insert " " $fpath "\n")
;;           )
;;              )
;;       $errorsPerFile
;;            )
;;      (insert "\n")
;;      )
;;   $bracketMatchList)
;; (insert "Done")
;;   (switch-to-buffer $outputBuffer)
;;   )
