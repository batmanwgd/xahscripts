;; -*- coding: utf-8 -*-

(delete-directory "~/web/xahlee_org/diklo/xx_xah_java_tutorial/" t )

(xah-make-downloadable-copy
 "~/web/xahlee_info/"
 [ "~/web/xahlee_info/java-a-day/" ]
 "~/web/xahlee_org/diklo/xx_xah_java_tutorial/")



(xah-find-replace-text "<nav id=\"t5\">
<ul>
<li><a href=\"http://xahlee.info/SpecialPlaneCurves_dir/specialPlaneCurves.html\">Curves</a></li>
<li><a href=\"http://xahlee.info/surface/gallery.html\">Surfaces</a></li>
<li><a href=\"http://xahlee.info/Wallpaper_dir/c0_WallPaper.html\">Wallpaper Groups</a></li>
<li><a href=\"http://xahlee.info/MathGraphicsGallery_dir/mathGraphicsGallery.html\">Gallery</a></li>
<li><a href=\"http://xahlee.info/math_software/mathPrograms.html\">Math Software</a></li>
<li><a href=\"http://xahlee.info/3d/index.html\">POV-Ray</a></li>
</ul>
<ul>
<li><a href=\"http://xahlee.info/js/js.html\">JavaScript</a></li>
<li><a href=\"http://xahlee.info/js/index.html\">HTML</a></li>
<li><a href=\"http://xahlee.info/js/css_index.html\">CSS</a></li>
</ul>
<ul>
<li><a href=\"http://xahlee.info/linux/linux_index.html\">Linux</a></li>
<li><a href=\"http://xahlee.info/perl-python/index.html\">Perl Python Ruby</a></li>
<li><a href=\"java.html\">Java</a></li>
<li><a href=\"http://xahlee.info/php/index.html\">PHP</a></li>
<li><a href=\"http://ergoemacs.org/emacs/emacs.html\">Emacs</a></li>
<li><a href=\"http://xahlee.info/comp/comp_lang.html\">Syntax</a></li>
<li><a href=\"http://xahlee.info/comp/unicode_index.html\">Unicode 😸 ♥</a></li>
<li><a href=\"http://xahlee.info/kbd/keyboarding.html\">Keyboard ⌨</a></li>
</ul>
<button id=\"i54391\" type=\"button\">Random Page</button><script async src=\"../random_page.js\"></script>"
 ""
 "~/web/xahlee_org/diklo/xx_xah_java_tutorial/" 
"\\.html$" t t t)

(xah-find-replace-text "<div id=\"share-buttons-97729\"></div><script defer src=\"../share_widgets.js\"></script>"
 ""
 "~/web/xahlee_org/diklo/xx_xah_java_tutorial/" 
"\\.html$" t t t)

