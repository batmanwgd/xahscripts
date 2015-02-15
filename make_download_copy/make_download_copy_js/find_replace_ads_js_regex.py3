# -*- coding: utf-8 -*-
# Python 3

# change all files in a dir.
# using mulitple regex/replace pairs

# last used at least: 2012-03-14

import re
import os
import sys
import shutil
import datetime

# if this this is not empty, then only these files will be processed
file_list = [
]

input_dir = sys.argv[1]
print(input_dir)

min_level = 1 # files and dirs inside input_dir are level 1.
max_level = 6 # inclusive

find_replace_list = [

(re.compile(r'''<button id="i54391" type="button">Random Page</button><script async src="(\.\./)*random_page.js"></script>''', re.U|re.M|re.DOTALL), r''),

(re.compile(r'''<div id="share-buttons-97729"></div><script defer src="(\.\./)*share_widgets.js"></script>''', re.U|re.M|re.DOTALL), r''),

(re.compile(r'''<section class="buy-book">
Want to master JavaScript in a week? Buy <a href="buy_xah_js_tutorial.html">Xah JavaScript Tutorial</a>.
<div class="pp_xah_js_tutorial">
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick" />
<input type="hidden" name="hosted_button_id" value="J3BC865C77JUC" />
<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!" />
<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1" />
</form>
</div>
</section>''', re.U|re.M|re.DOTALL), r''),

]

def replace_string_in_file(file_path):
   "Replaces all strings by regex in find_replace_list at file_path."
   backup_fname = file_path + "~re~"

   # print "reading:", file_path
   input_file = open(file_path, "rb")
   file_content = str(input_file.read(), "utf-8")
   input_file.close()

   num_replaced = 0
   for a_pair in find_replace_list:
      tem_tuple = re.subn(a_pair[0], a_pair[1], file_content)
      output_text = tem_tuple[0]
      num_replaced += tem_tuple[1]
      file_content = output_text

   if (num_replaced > 0):
      print(("◆ %d %s" % (num_replaced, file_path.replace("/cygdrive/c/Users/h3", "~")) ))

      shutil.copy2(file_path, backup_fname)
      output_file = open(file_path, "r+b")
      output_file.read() # we do this way to preserve file creation date
      output_file.seek(0)
      output_file.write(output_text.encode("utf-8"))
      output_file.truncate()
      output_file.close()

#      os.rename(file_path, backup_fname)
#      os.rename(tempName, file_path)

# def process_file(dummy, current_dir, file_list):
#    for child in file_list:
#       if re.search(r".+\.html$", child, re.U) and os.path.isfile(current_dir + "/" + child):
#          replace_string_in_file(current_dir + "/" + child)

# ────────── ────────── ────────── ────────── ──────────

print(datetime.datetime.now())
print("Input Dir:", input_dir)
for x in find_replace_list:
   print("Find regex:「{}」".format(x[0]))
   print("Replace pattern:「{}」".format(x[1]))
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

# os.path.walk(input_dir, process_file, "dummy")

print("Done.")
