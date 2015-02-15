 # -*- coding: utf-8 -*-

# remove existing
rm -rf /home/xah/web/xahlee_org/diklo/yy_xahlee_info

# copy dir
cp -r /home/xah/web/xahlee_info /home/xah/web/xahlee_org/diklo/yy_xahlee_info

# remove java doc
rm -rf /home/xah/web/xahlee_org/diklo/yy_xahlee_info/java8_doc

# remove xx files and temp files etc
python3 /home/xah/git/xahscripts/make_download_copy/delete_temp_files.py3 /home/xah/web/xahlee_org/diklo/yy_xahlee_info

# replace scripts and ads
python3 /home/xah/git/xahscripts/make_download_copy/find_replace_ads.py3 /home/xah/web/xahlee_org/diklo/yy_xahlee_info

# replace scripts and ads, by regex
python3 /home/xah/git/xahscripts/make_download_copy/find_replace_ads_regex.py3 /home/xah/web/xahlee_org/diklo/yy_xahlee_info

# delete backup
find /home/xah/web/xahlee_org/diklo/yy_xahlee_info -name "*~" -delete
