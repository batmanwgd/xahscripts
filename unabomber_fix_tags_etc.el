2009-01-03

(defun xxFindChapter (paraNum)
  "... given a paragraph number PARANUM, 
return a number that paragraph appears in."
  (interactive)
  (let (paraIndex elm currentIndex i)
    ;; paragraph index. Each item is the starting para of a chapter.
    (setq paraIndex '(1 6 10 24 33 38 44 45 59 77 87 93 99 111 114 121 125 136 140 143 161 167 171 180 207 213 ))

    (catch 'exit
      (setq i 0)
      (while (< i (length paraIndex))
        (setq elm (nth i paraIndex))
        (if (<= elm paraNum)
            (setq currentIndex i)
            (throw 'exit i)
          )
        (setq i (1+ i))
        )
      i )
))

(defun xxParaNumLinkify1 ()
  "Turn the text under the current cursor into a link like this:
“<a href=\"um-s26.html#p227\">¶227</a>”
The text under cursor must be of this form:
¶227
"
  (interactive)
  (let (paraNumStr chapterNumStr)
    (while 
        (search-forward-regexp "¶\\([0-9]+\\)" nil t)
      ;; (message (match-string-no-properties 1))
      (setq paraNumStr  (match-string-no-properties 1))
      (setq chapterNumStr
          (format "%02d" (xxFindChapter (string-to-number paraNumStr))))
      (replace-match
       (concat
        "<a href=\"um-s" 
        chapterNumStr
        ".html#p"
        paraNumStr
        "\">¶"
        paraNumStr
        "</a>"
        )
       t)
      )
))

(defun xxParaNumLinkify (p1 p2)
  "Turn the selected paragraph number into a link to its chapter.
For example:
if selected text is “227”, it becomes:
“<a href=\"um-s26.html#p227\">¶227</a>”
"
  (interactive "r")
  (let (paraNumStr chapterNumStr)
    (setq paraNumStr (buffer-substring-no-properties p1 p2))
    (setq chapterNumStr
          (format "%02d" (xxFindChapter (string-to-number paraNumStr))))
    (delete-region p1 p2)
    (insert 
     (concat
      "<a href=\"um-s"        
      chapterNumStr
      ".html#p"
      paraNumStr
      "\">¶"
      paraNumStr
      "</a>"
      )
     )
    ))

(defun xxParaNumInParenLinkify ()
  "Turn the cursor point's paragraph text into a link to its chapter.
For example:
if cursor is in the text “(Paragraph 227)”, it becomes:
“(<a href=\"um-s26.html#p227\">“Paragraph 227</a>)”
"
  (interactive)
  (let (p1 p2 paraNumStr chapterNumStr p3 p4)
    (search-backward "(")
    (search-forward " ")
    (setq p1 (point))
    (search-forward ")")
    (setq p2 (1- (point)))

    (setq paraNumStr (buffer-substring-no-properties p1 p2))
    (setq chapterNumStr
          (format "%02d" (xxFindChapter (string-to-number paraNumStr))))

    (search-backward "(")
    (setq p3 (point))
    (search-forward ")")
    (setq p4 (point))

    (delete-region p3 p4)
    (insert 
     (concat
      "(<a href=\"um-s" 
      chapterNumStr 
      ".html#p"
      paraNumStr
      "\">Paragraph "
      paraNumStr
      "</a>)"
      )
     )
    ))

; open a file, process it, save, close it
(defun xxFixTitleTag (fpath)
  "process the file at fullpath fpath ..."
  (let (mybuffer tt)
    (setq mybuffer (find-file fpath))
    (buffer-disable-undo)
    (goto-char (point-min))
    (search-forward-regexp "<h2>\\([^<]+\\)</h2>")
    (setq tt (match-string 1))

    (search-backward "<title>Industrial Society and its Future</title>" )
    (replace-match (concat  "<title>" tt "</title>"))

;    (save-buffer)
;    (kill-buffer mybuffer)
))

(my-process-file "/Users/xah/web/p/um/um-s02.html")

(my-process-file "um-s01.html")

(my-process-file "um-s02.html")
(my-process-file "um-s03.html")
(my-process-file "um-s04.html")
(my-process-file "um-s05.html")
(my-process-file "um-s06.html")
(my-process-file "um-s07.html")
(my-process-file "um-s08.html")
(my-process-file "um-s09.html")
(my-process-file "um-s10.html")
(my-process-file "um-s11.html")
(my-process-file "um-s12.html")
(my-process-file "um-s13.html")
(my-process-file "um-s14.html")
(my-process-file "um-s15.html")
(my-process-file "um-s16.html")
(my-process-file "um-s17.html")
(my-process-file "um-s18.html")
(my-process-file "um-s19.html")
(my-process-file "um-s20.html")
(my-process-file "um-s21.html")
(my-process-file "um-s22.html")
(my-process-file "um-s23.html")
(my-process-file "um-s24.html")
(my-process-file "um-s25.html")
(my-process-file "um-s26.html")
(my-process-file "um-s27.html")
