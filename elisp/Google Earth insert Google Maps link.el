;; -*- coding: utf-8 -*-
;; 2011-08-22
;; process all html files in a dir.
;; find any Google Earth link like this:
;; <a href="../../kml/East_Indies.kml" title="East Indies">⊕</a>
;; insert in front of it, a Google Maps link like this:
;; <a href="http://maps.google.com/maps?q=1.5%2C114.2" title="East Indies">✈</a>
;; the coordinates are from the kml file.

(setq inputDir "~/web/xahlee_org/p/" )

;; add a ending slash if not there
(when (not (string= "/" (substring inputDir -1) )) (setq inputDir (concat inputDir "/") ) )

;; files to process
(setq fileList 
      [
"~/web/xahlee_org/Whirlwheel_dir/windturbine.html"
"~/web/xahlee_org/Whirlwheel_dir/reflecting_disks/reflecting_disks.html"
"~/web/xahlee_org/Whirlwheel_dir/livermore.html"
"~/web/xahlee_org/surface/hyperboloid1/hyperboloid1.html"
"~/web/xahlee_org/Periodic_dosage_dir/what_is_Al_Jazeera.html"
"~/web/xahlee_org/Periodic_dosage_dir/t2/3dxm_conf_2006.html"
"~/web/xahlee_org/Periodic_dosage_dir/t1/reno_20061104.html"
"~/web/xahlee_org/Periodic_dosage_dir/t1/presences.html"
"~/web/xahlee_org/Periodic_dosage_dir/t1/aquarium.html"
"~/web/xahlee_org/Periodic_dosage_dir/las_vegas/luxor.html"
"~/web/xahlee_org/Periodic_dosage_dir/las_vegas/20031020_vegas.html"
"~/web/xahlee_org/Periodic_dosage_dir/lanci/wc2006.html"
"~/web/xahlee_org/Periodic_dosage_dir/lanci/wc2006-3.html"
"~/web/xahlee_org/Periodic_dosage_dir/lanci/t5.html"
"~/web/xahlee_org/p/titus/act3.html"
"~/web/xahlee_org/p/titus/act2s3.html"
"~/web/xahlee_org/p/time_machine/tm-ch04.html"
"~/web/xahlee_org/p/jeeves_and_the_phd.html"
"~/web/xahlee_org/p/Gullivers_Travels/gt4ch01.html"
"~/web/xahlee_org/p/Gullivers_Travels/gt3ch11.html"
"~/web/xahlee_org/p/Gullivers_Travels/gt3ch08.html"
"~/web/xahlee_org/p/Gullivers_Travels/gt3ch07.html"
"~/web/xahlee_org/p/Gullivers_Travels/gt3ch01.html"
"~/web/xahlee_org/p/Gullivers_Travels/gt1ch01.html"
"~/web/xahlee_org/p/alice/alice-ch01.html"
"~/web/xahlee_org/p/1002_of_Scheherazade.html"
"~/web/xahlee_org/music/you_are_so_vain.html"
"~/web/xahlee_org/music/poor_unfortunate_souls.html"
"~/web/xahlee_org/music/one_night_in_Bangkok.html"
"~/web/xahlee_org/emacs/google-earth.html"
"~/web/xahlee_org/dinju/terdi.html"
"~/web/xahlee_org/dinju/plane_wreck_girls.html"
"~/web/xahlee_org/dinju/Petronas_towers.html"
"~/web/xahlee_org/dinju/neuschwanstein.html"
"~/web/xahlee_org/dinju/misc.html"
"~/web/xahlee_org/dinju/Khajuraho.html"
"~/web/xahlee_org/dinju/jeronimos.html"
"~/web/xahlee_org/dinju/igloo_hotel.html"
"~/web/xahlee_org/dinju/hyperboloid.html"
"~/web/xahlee_org/dinju/geodesic_dome.html"
"~/web/xahlee_org/dinju/eden_project.html"
"~/web/xahlee_org/dinju/duomo_di_milano.html"
"~/web/xahlee_org/dinju/cologne_cathedral.html"
"~/web/xahlee_org/dinju/atomium.html"
"~/web/xahlee_org/dinju/aral_sea.html"
       ]
      )

(defun my-process-file-xnote (fPath)
  "Process the file at FPATH …"
  (let (
        myBuffer
        kmlFilePath
        ξxCoord ξyCoord
        tempStr
        newText
        titleStart
        tagStart

        (ξi 0) ξtitle
        (changedItems '())
        )
    ;; (require 'sgml-mode)
    (when t
      (setq myBuffer (find-file fPath))
      (goto-char 1)
      (while
          (search-forward ".kml\" title=\"" nil t)
        (setq titleStart (point))

        (search-backward "<" nil t)
        (setq tagStart (point))
        
        (when (not (looking-back ">✈</a>[[:space:]]*"))
          ;; get title
          (goto-char titleStart)
          (skip-chars-forward "^\"")
          (setq ξtitle (buffer-substring-no-properties titleStart (point)))

          ;; get kml file path
          (search-backward ".kml\" title=\"" nil t)
          (setq kmlFilePath (thing-at-point 'filename)  )

          ;; get coordinates
          (with-temp-buffer
            (insert-file-contents kmlFilePath nil nil nil t)
            (goto-char 1)
            (let (ξcoord ξcoordList p3 p4 )
              (goto-char 1)
              (search-forward "<coordinates>" nil t)
              (setq p3 (point))
              (search-forward "</coordinates>" nil t)
              (backward-char 14)
              (setq p4 (point))
              (setq ξcoord (buffer-substring-no-properties p3 p4))
              (setq ξcoordList (split-string ξcoord " *, *" t)  )
              (setq ξxCoord (elt ξcoordList 0) )
              (setq ξyCoord (elt ξcoordList 1) )
              )
            )
          
          (goto-char tagStart)
          (setq newText (concat "<a href=\"http://maps.google.com/maps?q=" ξyCoord "%2C" ξxCoord "\"" " title=\"" ξtitle "\">✈</a>\n"))
          (insert newText)
          (setq ξi (1+ ξi))

          ;; put the new entries into a list, for later reporting
          (setq changedItems (cons newText changedItems) )
          )

        ;; go back to the point, for the loop to advance
        (search-forward ".kml\" title=\"" nil t)
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
  (setq outputBuffer "*xah add Google map link output*" )
  (with-output-to-temp-buffer outputBuffer 
    (mapc 'my-process-file-xnote fileList)
    ;; (mapc 'my-process-file-xnote (find-lisp-find-files inputDir "\\.html$"))
    (princ "Done deal!")
    )
  )


;; 2011-08-24
;; -------------------------------------------
;; 3 ~/web/xahlee_org/Whirlwheel_dir/windturbine.html

;; <a href="http://maps.google.com/maps?q=41.49%2C-94.32" title="Adel, Iowa, USA">✈</a>


;; <a href="http://maps.google.com/maps?q=55.692179%2C12.670509" title="Copenhagen, Denmark">✈</a>


;; <a href="http://maps.google.com/maps?q=66.827370%2C23.436459" title="Aapua wind park">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/Whirlwheel_dir/reflecting_disks/reflecting_disks.html

;; <a href="http://maps.google.com/maps?q=34.078611%2C-107.617778" title="VLA">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/Whirlwheel_dir/livermore.html

;; <a href="http://maps.google.com/maps?q=37.7497%2C-121.6832" title="Altamount Pass Wind Farm">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/surface/hyperboloid1/hyperboloid1.html

;; <a href="http://maps.google.com/maps?q=34.6809%2C135.1873" title="Kobe Port Tower">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/Periodic_dosage_dir/what_is_Al_Jazeera.html

;; <a href="http://maps.google.com/maps?q=25.31%2C51.2" title="Qatar">✈</a>


;; -------------------------------------------
;; 6 ~/web/xahlee_org/Periodic_dosage_dir/t2/3dxm_conf_2006.html

;; <a href="http://maps.google.com/maps?q=36.987867%2C-121.984567" title="Gas Station at Santa Cruz">✈</a>


;; <a href="http://maps.google.com/maps?q=36.352383%2C-121.899500" title="Somewhere on Highway 1">✈</a>


;; <a href="http://maps.google.com/maps?q=35.433350%2C-120.886133" title="Morro Strand State Beach">✈</a>


;; <a href="http://maps.google.com/maps?q=34.96748%2C-120.57406" title="Guadalupe, CA, USA">✈</a>


;; <a href="http://maps.google.com/maps?q=34.66186%2C-120.45651" title="Lompoc">✈</a>


;; <a href="http://maps.google.com/maps?q=33.664965%2C-117.880089" title="Ayres Suite">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/Periodic_dosage_dir/t1/reno_20061104.html

;; <a href="http://maps.google.com/maps?q=39.5297%2C-119.8127" title="Reno, NV, USA">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/Periodic_dosage_dir/t1/presences.html

;; <a href="http://maps.google.com/maps?q=37.4025%2C-122.0685" title="Mountain View">✈</a>


;; -------------------------------------------
;; 2 ~/web/xahlee_org/Periodic_dosage_dir/t1/aquarium.html

;; <a href="http://maps.google.com/maps?q=36.964%2C-122.018" title="Santa Cruz Beach">✈</a>


;; <a href="http://maps.google.com/maps?q=36.6180%2C-121.9019" title="Monterey Bay Aquarium">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/Periodic_dosage_dir/las_vegas/luxor.html

;; <a href="http://maps.google.com/maps?q=25.683333%2C32.65" title="Luxor city">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/Periodic_dosage_dir/las_vegas/20031020_vegas.html

;; <a href="http://maps.google.com/maps?q=36.1027%2C-115.1730" title="Las Vegas">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/Periodic_dosage_dir/lanci/wc2006.html

;; <a href="http://maps.google.com/maps?q=8.54%2C1.06" title="Togo">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/Periodic_dosage_dir/lanci/wc2006-3.html

;; <a href="http://maps.google.com/maps?q=51.5558%2C7.0675" title="Gelsenkirchen">✈</a>


;; -------------------------------------------
;; 2 ~/web/xahlee_org/Periodic_dosage_dir/lanci/t5.html

;; <a href="http://maps.google.com/maps?q=40.0155%2C-79.0781" title="Harley-Davidson Somerset">✈</a>


;; <a href="http://maps.google.com/maps?q=40.068%2C-80.8628" title="Cracker Barrel">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/music/you_are_so_vain.html

;; <a href="http://maps.google.com/maps?q=44.88%2C-63.99" title="Nova Scotia">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/music/poor_unfortunate_souls.html

;; <a href="http://maps.google.com/maps?q=38.60%2C51.43" title="Caspian Sea">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/music/one_night_in_Bangkok.html

;; <a href="http://maps.google.com/maps?q=13.7289%2C100.5236" title="Bangkok">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/emacs/google-earth.html

;; <a href="http://maps.google.com/maps?q=36.1027%2C-115.1730" title="Las Vegas">✈</a>


;; -------------------------------------------
;; 2 ~/web/xahlee_org/dinju/terdi.html

;; <a href="http://maps.google.com/maps?q=-26.1976%2C 28.0506" title="Johannesburg">✈</a>


;; <a href="http://maps.google.com/maps?q=39.95732%2C26.23880" title="Troy">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/dinju/plane_wreck_girls.html

;; <a href="http://maps.google.com/maps?q=45.326369%2C33.034698" title="sea plane wreck">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/dinju/Petronas_towers.html

;; <a href="http://maps.google.com/maps?q=3.15799%2C101.711707" title="Petronas Towers">✈</a>


;; -------------------------------------------
;; 2 ~/web/xahlee_org/dinju/neuschwanstein.html

;; <a href="http://maps.google.com/maps?q=27.491667%2C89.363333" title="Taktshang monastery">✈</a>


;; <a href="http://maps.google.com/maps?q=47.557644%2C10.749956" title="Schloss Neuschwanstein Castle">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/dinju/misc.html

;; <a href="http://maps.google.com/maps?q=28.55300442935254%2C77.2584023916091" title="Lotus Temple">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/dinju/Khajuraho.html

;; <a href="http://maps.google.com/maps?q=24.8525%2C79.920833" title="Khajuraho Temple">✈</a>


;; -------------------------------------------
;; 3 ~/web/xahlee_org/dinju/jeronimos.html

;; <a href="http://maps.google.com/maps?q=38.798586%2C -9.388167" title="Sintra Portugal">✈</a>


;; <a href="http://maps.google.com/maps?q=38.69163%2C-9.21605" title="Belem Tower">✈</a>


;; <a href="http://maps.google.com/maps?q=38.69716%2C-9.206431" title="Jeronimos Monastery">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/dinju/igloo_hotel.html

;; <a href="http://maps.google.com/maps?q=63.187689%2C-149.359989" title="Igloo hotel">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/dinju/hyperboloid.html

;; <a href="http://maps.google.com/maps?q=34.6809%2C135.1873" title="Kobe Port Tower">✈</a>


;; -------------------------------------------
;; 3 ~/web/xahlee_org/dinju/geodesic_dome.html

;; <a href="http://maps.google.com/maps?q=43.863777%2C-116.508741" title="Emmett High School">✈</a>


;; <a href="http://maps.google.com/maps?q=45.5140%2C-73.5315" title="Montreal Biosphere↗">✈</a>


;; <a href="http://maps.google.com/maps?q=28.37534%2C-81.54949" title="Spaceship Earth">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/dinju/eden_project.html

;; <a href="http://maps.google.com/maps?q=50.359%2C-4.743" title="The Eden Project">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/dinju/duomo_di_milano.html

;; <a href="http://maps.google.com/maps?q=45.464167%2C9.190833" title="Duomo di Milano">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/dinju/cologne_cathedral.html

;; <a href="http://maps.google.com/maps?q=50.9412%2C6.9576" title="Cologne Cathedral">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/dinju/atomium.html

;; <a href="http://maps.google.com/maps?q=50.89491%2C4.34153" title="Atomium">✈</a>


;; -------------------------------------------
;; 1 ~/web/xahlee_org/dinju/aral_sea.html

;; <a href="http://maps.google.com/maps?q=45.059%2C59.868" title="Aral Sea">✈</a>


;; Done deal!
