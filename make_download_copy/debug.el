; 2008-06-12

; make my website emacs tutorial into a zip for download

; primarily, this script will make a zip file out of a directory and place the zip on a dest dir.
; however, there are few little things that needs to be done when archiving a dir for distribution:
; • remove temp files and dir that isn't supposed to be pulic. Temp are those starting with “xx”
; • remove emacs backup files, osx's “.DS_Store”
; • create a parent dir and add css files and icon files
; • for each file, remove the javascript lines that are Google's web stat bug
; • for each file, fix no longer correct relative links to “http://xahlee.org/...”.

;;;; user parameters

; root dir to work with
(setq webroot "/Users/xah/web/") ; must end in slash

; list of source dirs relative to webroot
(setq sourceDirsList (list "p/time_machine"))

; destination dir path, relative to webroot
(setq destDirRelativePath "diklo")

; dest zip archive name (without the “.zip” suffix)
(setq zipCoreName "time_machine")

; whether to use gzip or zip.
(setq use-gzip-p nil)

;;;;

(setq destRoot (concat webroot destDirRelativePath "/"))
(setq destDir (concat destRoot zipCoreName "/"))

;;;; copy to destination
(mapcar
 (lambda (x)
   (let (fromDir toDir)
     (setq fromDir (concat webroot x))
     (setq toDir
           (xah-drop-last-slash (concat webroot destDirRelativePath "/" zipCoreName "/" x)) )
     (make-directory toDir t)
     (shell-command (concat "cp -R " fromDir " " toDir))
     )
   )
 sourceDirsList)

; copy the style sheets over, and icons dir
(shell-command (concat "cp /Users/xah/web/lang.css " destDir))
(shell-command (concat "cp /Users/xah/web/lbasic.css " destDir))
(shell-command (concat "cp /Users/xah/web/lit.css " destDir))
(shell-command (concat "cp -R /Users/xah/web/ics " destDir))

; remove emacs backup files, temp files, mac os x files, etc.
(shell-command (concat "find " destDir " -name \"*~\"  -exec rm {} \\;"))
(shell-command (concat "find " destDir " -name \"#*#\"  -exec rm {} \\;"))
(shell-command (concat "find " destDir " -type f -name \"xx*\"  -exec rm {} \\;"))
(shell-command (concat "find " destDir " -type f -name \"\\.DS_Store\"  -exec rm {} \\;"))
(shell-command (concat "find " destDir " -type f -empty -exec rm {} \\;"))
(shell-command (concat "find " destDir " -type d -empty -exec rmdir {} \\;"))
(shell-command (concat "find " destDir " -type d -name \"xx*\" -exec rm -R {} \\;"))

;; change local links to “http://” links. Delete the google javascript snippet, and other small fixes.
(setq make-backup-files nil)
(require 'find-lisp)
(mapc (lambda (x)
        (mapc
         (lambda (fPath) (clean-file fPath (concat webroot (substring fPath (length destDir)))))
         (find-lisp-find-files (concat destDir "/" x) "\\.html$"))
        )
      sourceDirsList
)

;; zip the dir
(setq default-directory (concat webroot destDirRelativePath "/"))
(when (equal
       0 
       (if use-gzip-p
           (shell-command (concat "tar cfz " zipCoreName ".tar.gz " zipCoreName))
         (shell-command (concat "zip -r " zipCoreName ".zip " zipCoreName))
         ))
  (shell-command (concat "rm -R " destDir))
)

;;----------------------------

; read me text
(setq readMeText "
This is “Xah'S Emacs Tutorial” by Xah Lee.

--------------------------------------------------
The “emacs” dir is emacs and elisp tutorial. The “elisp” dir is elisp manual.

--------------------------------------------------
The tutorial is updated few times a year. The download location is:
http://xahlee.org/diklo/xah_emacs_tutorial.zip

--------------------------------------------------
PERMISSION TO COPY

“Xah'S Emacs Tutorial” is licensed under
“Creative Commons Attribution-Noncommercial-No Derivative Works 3.0 United States License.”
available at
http://creativecommons.org/licenses/by-nc-nd/3.0/us/

The elisp manual is licensed under
“GNU Free Documentation License”, available at
http://www.gnu.org/copyleft/fdl.html

")

;; create the read me file.
(find-file (concat destDir "read_me.txt"))
(insert readMeText)
(save-buffer)
(kill-this-buffer)
