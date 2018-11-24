# -*- coding: utf-8 -*-

require 'fileutils'

outpath ="~/web/xahlee_org/diklo/xx_xah_js_tutorial"

# replace scripts and ads
%x[python3 ../find_replace_ads.py3 #{outpath}]

# remove existing
if File.exist?(outpath + "/js/blog.xml")
then FileUtils.remove_dir(outpath + "/js/blog.xml")
end

# remove xx files and temp files etc
%x[python3 ~/git/xahscripts/make_download_copy/delete_temp_files.py3 #{outpath}]

# p 'done'
