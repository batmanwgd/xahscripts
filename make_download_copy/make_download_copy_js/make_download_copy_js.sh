# -*- coding: utf-8 -*-

# remove xx files and temp files etc
python3 /home/xah/git/xahscripts/make_download_copy/delete_temp_files.py3 /home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial

# replace scripts and ads
python3 /home/xah/git/xahscripts/make_download_copy/find_replace_ads.py3 /home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial

# replace scripts and ads, by regex
python3 /home/xah/git/xahscripts/make_download_copy/find_replace_ads_regex.py3 /home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial

# replace scripts and ads, js specific
python3 /home/xah/git/xahscripts/make_download_copy/make_download_copy_js/find_replace_ads_js.py3 /home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial

# replace scripts and ads, by regex, js specific
python3 /home/xah/git/xahscripts/make_download_copy/make_download_copy_js/find_replace_ads_js_regex.py3 /home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial

rm  /home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial/js/blog.xml

# delete backup
find /home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial -name "*~" -delete
