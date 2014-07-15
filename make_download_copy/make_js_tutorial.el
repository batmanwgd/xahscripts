;; -*- coding: utf-8 -*-

 (xah-make-downloadable-copy
  "~/web/xahlee_info/"
  [
"~/web/xahlee_info/js/"
"~/web/xahlee_info/javascript_ecma-262_5.1_2011/"
"~/web/xahlee_info/jquery_doc/"
"~/web/xahlee_info/node_api/"
   ]
  "~/web/xahlee_org/diklo/xx_xah_js_tutorial/")



(delete-files-by-regex "~/web/xahlee_org/diklo/xx_xah_js_tutorial/" "^backbone")
(delete-file "~/web/xahlee_org/diklo/xx_xah_js_tutorial/js/blog.xml")
(delete-file "~/web/xahlee_org/diklo/xx_xah_js_tutorial/js/blog_past.xml.gz")



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
<li><a href=\"http://xahlee.info/linux/linux_index.html\">Linux</a></li>
<li><a href=\"http://xahlee.info/perl-python/index.html\">Perl Python Ruby</a></li>
<li><a href=\"http://xahlee.info/java-a-day/java.html\">Java</a></li>
<li><a href=\"http://xahlee.info/php/index.html\">PHP</a></li>
" "<nav id=\"t5\"><ul>" "/home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial/js/" "\\.html$" t t)

(xah-find-replace-text "<li><a href=\"http://ergoemacs.org/emacs/emacs.html\">Emacs</a></li>
<li><a href=\"http://xahlee.info/comp/comp_lang.html\">Syntax</a></li>
<li><a href=\"http://xahlee.info/comp/unicode_index.html\">☢ ∑ ∞ 😄 ♥</a></li>
<li><a href=\"http://xahlee.info/kbd/keyboarding.html\">Keyboard ⌨</a></li>
</ul>" "</ul>" "/home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial/js/" "\\.html$" t t)

(xah-find-replace-text "<button id=\"i54391\" type=\"button\">Random Page</button><script async src=\"../random_page.js\"></script>" "" "/home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial/" "\\.html$" t t)

(xah-find-replace-text "<button id=\"i54391\" type=\"button\">Random Page</button><script async src=\"../../random_page.js\"></script>" "" "/home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial/" "\\.html$" t t)

(xah-find-replace-text "<section class=\"buy-book\"><p>Want to master JavaScript in a month? Commit. Buy this tutorial for $19. You also get <a href=\"index.html\">Xah's HTML Tutorial</a> and <a href=\"css_index.html\">Xah's CSS Tutorial</a>.</p>

<div class=\"pp_xah_js_tutorial\"><form action=\"https://www.paypal.com/cgi-bin/webscr\" method=\"post\" target=\"_top\">
<input type=\"hidden\" name=\"cmd\" value=\"_s-xclick\">
<input type=\"hidden\" name=\"hosted_button_id\" value=\"TDVP53GAZSRCQ\">
<input type=\"image\" src=\"https://www.paypalobjects.com/en_US/i/btn/btn_buynowCC_LG.gif\" border=\"0\" name=\"submit\" alt=\"PayPal - The safer, easier way to pay online!\">
<img alt=\"\" border=\"0\" src=\"https://www.paypalobjects.com/en_US/i/scr/pixel.gif\" width=\"1\" height=\"1\">
</form>
</div>

</section>" "" "/home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial/js/" "\\.html$" t t)

(xah-find-replace-text "<p>buy this tutorial for $10. Use the paypal button below. In the comment field, put “css tutorial”. I'll email you the download link. Make sure your email address is included and correct.</p>" "" "/home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial/js/" "\\.html$" t t)

(delete-files-by-regex "/home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial/" "~\\'")
