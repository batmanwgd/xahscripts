; -*- coding: utf-8 -*-

; 2008-03-10
; replace html title tag's content by the h1 header tag content
; in the dir ~/web/surface/
; e.g.
; ~/web/surface/unduloid/unduloid.html
; there are <title>Surface Gallery</title>
; and <h1>Unduloid</h1>
; and the title should be <title>Unduloid</title>

(defun replace-title-by-header (fname)
  "Replace html file's title content by h1's content ."
  (interactive)
  (let (x1 x2 header)
; insert file content into a temp buffer
; get h1
; replace title
; write buffer into the file
(save-current-buffer
     (set-buffer (get-buffer-create " tmp829toc32"))
     (goto-char (point-min))
     (insert-file-contents fname nil nil nil t)
     (setq x1 (search-forward "<h1>"))
     (search-forward "</h1>")
     (setq x2 (search-backward "<"))
     (setq header (buffer-substring-no-properties x1 x2))
     (goto-char (point-min))
     (if
         (re-search-forward "<title>Surface Gallery</title>" nil t)
         (progn   
           (replace-match (concat "<title>" header "</title>") t t)
           (write-file fname)
           )
       (progn (message fname))
       )
     )
))

(replace-title-by-header "~/web/surface/boys_apery/boys_apery.html")

(mapcar 'replace-title-by-header
        (list
;
        )
)

(defun replace-title-by-other-header (fname)
  "Replace html file's title content by another file's h1's content ."
  (interactive)
  (let (x1 x2 header)
     (setq header (get-html-file-title (replace-regexp-in-string "_jv_" "" fname)))
(save-current-buffer
     (set-buffer (get-buffer-create " tmp829toc32"))
     (goto-char (point-min))
     (insert-file-contents fname nil nil nil t)
     (goto-char (point-min))
     (if
         (re-search-forward "<title>Surface Gallery</title>" nil t)
         (progn   
           (replace-match (concat "<title>" header "</title>") t t)
           (write-file fname)
           )
       (progn (message fname))
       )
     )
))

(replace-title-by-other-header "~/web/surface/barth_sextic/_jv_barth_sextic.html")

(mapcar 'replace-title-by-other-header
        (list
"~/web/surface/barth_sextic/_jv_barth_sextic.html"
"~/web/surface/boys_apery/_jv_boys_apery.html"
"~/web/surface/boys_bryant-kusner/_jv_boys_bryant-kusner.html"
"~/web/surface/breather/_jv_breather.html"
"~/web/surface/breather_p/_jv_breather_p.html"
"~/web/surface/catalan/_jv_catalan.html"
"~/web/surface/catenoid/_jv_catenoid.html"
"~/web/surface/catenoid-enneper/_jv_catenoid-enneper.html"
"~/web/surface/catenoid_fence/_jv_catenoid_fence.html"
"~/web/surface/cayley_cubic/_jv_cayley_cubic.html"
"~/web/surface/chen_gackstatter/_jv_chen_gackstatter.html"
"~/web/surface/clebsch_cubic/_jv_clebsch_cubic.html"
"~/web/surface/conic_k-1_sor/_jv_conic_k-1_sor.html"
"~/web/surface/costa/_jv_costa.html"
"~/web/surface/costa-h-m/_jv_costa-h-m.html"
"~/web/surface/cross-cap/_jv_cross-cap.html"
"~/web/surface/cyclide/_jv_cyclide.html"
"~/web/surface/decocube/_jv_decocube.html"
"~/web/surface/dini/_jv_dini.html"
"~/web/surface/double_enneper/_jv_double_enneper.html"
"~/web/surface/ellipsoid/_jv_ellipsoid.html"
"~/web/surface/enneper/_jv_enneper.html"
"~/web/surface/gyroid/_jv_gyroid.html"
"~/web/surface/helicoid-catenoid/_jv_helicoid-catenoid.html"
"~/web/surface/henneberg/_jv_henneberg.html"
"~/web/surface/hyperbolic-paraboloid/_jv_hyperbolic-paraboloid.html"
"~/web/surface/hyperbolic_k1_sor/_jv_hyperbolic_k1_sor.html"
"~/web/surface/hyperboloid1/_jv_hyperboloid1.html"
"~/web/surface/hyperboloid2/_jv_hyperboloid2.html"
"~/web/surface/inverted_boy/_jv_inverted_boy.html"
"~/web/surface/k1-sor/_jv_k1-sor.html"
"~/web/surface/karcher_jd_st/_jv_karcher_jd_st.html"
"~/web/surface/karcher_je_st/_jv_karcher_je_st.html"
"~/web/surface/kink/_jv_kink.html"
"~/web/surface/klein_bottle/_jv_klein_bottle.html"
"~/web/surface/kuen/_jv_kuen.html"
"~/web/surface/kummer/_jv_kummer.html"
"~/web/surface/kusner_ds/_jv_kusner_ds.html"
"~/web/surface/lidinoid/_jv_lidinoid.html"
"~/web/surface/lopez-ros/_jv_lopez-ros.html"
"~/web/surface/moebius_strip/_jv_moebius_strip.html"
"~/web/surface/monkey_saddle/_jv_monkey_saddle.html"
"~/web/surface/orthocircles/_jv_orthocircles.html"
"~/web/surface/paraboloid/_jv_paraboloid.html"
"~/web/surface/planar-enneper/_jv_planar-enneper.html"
"~/web/surface/pseudosphere/_jv_pseudosphere.html"
"~/web/surface/riemann/_jv_riemann.html"
"~/web/surface/right_conoid/_jv_right_conoid.html"
"~/web/surface/saddle_tower/_jv_saddle_tower.html"
"~/web/surface/scherk/_jv_scherk.html"
"~/web/surface/scherk_w_handle/_jv_scherk_w_handle.html"
"~/web/surface/schoen_no-go_thm/_jv_schoen_no-go_thm.html"
"~/web/surface/schwarz_h_family/_jv_schwarz_h_family.html"
"~/web/surface/schwarz_pd_family/_jv_schwarz_pd_family.html"
"~/web/surface/sievert-enneper/_jv_sievert-enneper.html"
"~/web/surface/skew_4noid/_jv_skew_4noid.html"
"~/web/surface/sphere/_jv_sphere.html"
"~/web/surface/spherical_helicoid/_jv_spherical_helicoid.html"
"~/web/surface/steiner/_jv_steiner.html"
"~/web/surface/symmetric_4noid/_jv_symmetric_4noid.html"
"~/web/surface/torus/_jv_torus.html"
"~/web/surface/twisted_scherk/_jv_twisted_scherk.html"
"~/web/surface/unduloid/_jv_unduloid.html"
"~/web/surface/wavy_enneper/_jv_wavy_enneper.html"
"~/web/surface/whitney_umbrella/_jv_whitney_umbrella.html"
        )
)

(defun get-html-file-title (fname)
"Return FNAME <title> tag's text.
Assumes that the file contains the string
“<title>…</title>”."
 (let (x1 x2 linkText)
   (with-temp-buffer
     (insert-file-contents fname nil nil nil t)
     (goto-char 1)
     (setq x1 (search-forward "<title>"))
     (search-forward "</title>")
     (setq x2 (search-backward "<"))
     (buffer-substring-no-properties x1 x2)
     )
   ))

(defun get-html-file-h1-header (fname)
"Return html fname's <h1> tag's text."
 (let (x1 x2 linkText)
   (save-current-buffer
     (set-buffer (get-buffer-create " tmp8293"))
     (goto-char (point-min))
     (insert-file-contents fname nil nil nil t)

     (setq x1 (search-forward "<title>"))
     (search-forward "</title>")
     (setq x2 (search-backward "<"))
     (buffer-substring-no-properties x1 x2))))
