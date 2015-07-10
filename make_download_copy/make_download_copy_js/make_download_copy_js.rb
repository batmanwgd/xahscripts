 # -*- coding: utf-8 -*-

require 'fileutils'

outpath ="/home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial"
inpath ="/home/xah/web/xahlee_info/js"

# replace scripts and ads
%x[python3 find_replace_ads_js.py3 #{outpath}]
%x[python3 find_replace_ads_js_regex.py3 #{outpath}]

# remove existing
if File.exist?("/home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial/js/blog.xml")
then FileUtils.remove_dir("/home/xah/web/xahlee_org/diklo/xx_xah_js_tutorial/js/blog.xml")
end

# remove xx files and temp files etc
%x[python3 /home/xah/git/xahscripts/make_download_copy/delete_temp_files.py3 #{outpath}]

p 'done'
