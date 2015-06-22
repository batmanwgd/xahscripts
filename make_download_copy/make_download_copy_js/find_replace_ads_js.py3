# -*- coding: utf-8 -*-
# Python 3

# find & replace strings in a dir

import os, sys, shutil, re
import datetime

# if this this is not empty, then only these files will be processed
file_list = [
]

# directory to skip
dir_ignore = []

input_dir = sys.argv[1]
print(input_dir)

input_dir = os.path.normpath(input_dir)

min_level = 1 # files and dirs inside input_dir are level 1.
max_level = 7 # inclusive

print_filename_when_no_change = False

# • remember to remove js/ex dir
# • many pages don't have double ads

find_replace_list = [

('''<script>(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');ga('create','UA-10884311-1','xahlee.info');ga('require','displayfeatures');ga('send','pageview');</script>''',''),

('''<nav id="t5">
<ul>
<li><a href="http://xahlee.info/math/math_index.html">Math</a></li>
<li><a href="http://xahlee.info/comp/comp_index.html">Programing</a></li>
<li><a href="http://xahlee.info/comp/unicode_index.html">Unicode ♥</a></li>
<li><a href="http://xahlee.info/kbd/keyboarding.html">Keyboard ⌨</a></li>
</ul>''','''<nav id="t5">'''),

('''<script>
amzn_assoc_ad_type = "responsive_search_widget";
amzn_assoc_tracking_id = "xahhome-20";
amzn_assoc_marketplace = "amazon";
amzn_assoc_region = "US";
amzn_assoc_placement = "";
amzn_assoc_search_type = "search_widget";
amzn_assoc_width = "auto";
amzn_assoc_height = "auto";
amzn_assoc_default_search_category = "";
amzn_assoc_default_search_key = "";
amzn_assoc_theme = "light";
amzn_assoc_bg_color = "FFFFFF";
</script>''',''),

('''<div class="pp93653">
Buy xahlee.info for offline reading.
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_xclick">
<input type="hidden" name="business" value="JPHAB7F7QZRPC">
<input type="hidden" name="lc" value="US">
<input type="hidden" name="item_name" value="xahlee.info content">
<input type="hidden" name="amount" value="49.00">
<input type="hidden" name="currency_code" value="USD">
<input type="hidden" name="button_subtype" value="services">
<input type="hidden" name="no_note" value="0">
<input type="hidden" name="cn" value="Add special instructions to the seller:">
<input type="hidden" name="no_shipping" value="1">
<input type="hidden" name="bn" value="PP-BuyNowBF:btn_buynowCC_LG.gif:NonHosted">
<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
</form>
</div>''',''),

('''<section class="buy-book">
Buy <a href="buy_xah_js_tutorial.html">Xah JavaScript Tutorial</a>.
<div class="pp_xah_js_tutorial">
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick" />
<input type="hidden" name="hosted_button_id" value="J3BC865C77JUC" />
<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!" />
<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1" />
</form>
</div>
</section>''',''),

]



for x in find_replace_list:
    if len(x) != 2:
        sys.exit("Error: replacement pair has more than 2 elements. Probably missing a comma.")

def replace_string_in_file(file_path):
    "Replaces all findStr by repStr in file file_path"
    backup_fname = file_path + "~bk~"

    print ("reading:", file_path)
    input_file = open(file_path, "r", encoding="utf-8")
    file_content = input_file.read()
    input_file.close()

    num_replaced = 0
    for a_pair in find_replace_list:
        num_replaced += file_content.count(a_pair[0])
        output_text = file_content.replace(a_pair[0], a_pair[1])
        file_content = output_text

    if num_replaced > 0:
        print("◆ ", num_replaced, " ", file_path.replace(os.sep, "/"))
        shutil.copy2(file_path, backup_fname)
        output_file = open(file_path, "w")
        output_file.write(output_text)
        output_file.close()
    else:
        if print_filename_when_no_change == True:
            print("no change:", file_path)

#────────── ────────── ────────── ────────── ──────────

print(datetime.datetime.now())
print("Input Dir:", input_dir)
for x in find_replace_list:
   print("Find string:「{}」".format(x[0]))
   print("Replace string:「{}」".format(x[1]))
   print("\n")

if (len(file_list) != 0):
   for ff in file_list: replace_string_in_file(os.path.normpath(ff) )
else:
    for dirPath, subdirList, fileList in os.walk(input_dir):
        curDirLevel = dirPath.count( os.sep) - input_dir.count( os.sep)
        curFileLevel = curDirLevel + 1
        if min_level <= curFileLevel <= max_level:
            for fName in fileList:
                if (re.search(r"\.html$", fName, re.U)):
                    replace_string_in_file(dirPath + os.sep + fName)
                    # print ("level %d,  %s" % (curFileLevel, os.path.join(dirPath, fName)))

print("Done.")
