# -*- coding: utf-8 -*-
# Python

# change all files in a dir. 
# using mulitple regex/replace pairs 

# last used at least: 2012-03-14

import os, sys, shutil, re

input_dir = "/cygdrive/c/Users/h3/web/xahlee_org/Periodic_dosage_dir/bangu"
input_dir = "/cygdrive/c/Users/h3/web/xahlee_org/Periodic_dosage_dir/lanci"
input_dir = "/cygdrive/c/Users/h3/web/xahlee_org/Periodic_dosage_dir/las_vegas"
input_dir = "/cygdrive/c/Users/h3/web/xahlee_org/SpecialPlaneCurves_dir/Seashell_dir"


find_replace_list = [

(re.compile(ur"""<img src="([^"]+?)" alt="([^"]+?)" width="([0-9]+)" height="([0-9]+)">""", re.U|re.M),
ur"""<img src="\1" alt="\2" width="\3" height="\4" />"""),

# (re.compile(ur"""<img src="([^"]+?)" alt="([^"]+?)" width="([0-9]+)" height="([0-9]+)">
# <figcaption>""", re.U|re.M),
# ur"""<img src="\1" alt="\2" width="\3" height="\4" />
# <figcaption>"""),

# (re.compile(ur"""title="(\d+)x(\d+)">❐</a>""",re.U|re.M),
# ur"""title="\1×\2">❐</a>"""),
]

def replace_string_in_file(file_path):
   "Replaces all strings by regex in find_replace_list at file_path."
   backup_fname = file_path + "~re~"

   # print "reading:", file_path
   input_file = open(file_path, "rb")
   file_content = unicode(input_file.read(), "utf-8")
   input_file.close()

   num_replaced = 0
   for a_pair in find_replace_list:
      tem_tuple = re.subn(a_pair[0], a_pair[1], file_content)
      output_text = tem_tuple[0]
      num_replaced += tem_tuple[1]
      file_content = output_text

   if (num_replaced > 0):
      print ("◆ %d %s" % (num_replaced, file_path.replace("/cygdrive/c/Users/h3", "~")) )

      shutil.copy2(file_path, backup_fname)
      output_file = open(file_path, "r+b")
      output_file.read() # we do this way to preserve file creation date
      output_file.seek(0)
      output_file.write(output_text.encode("utf-8"))
      output_file.truncate()
      output_file.close()

#      os.rename(file_path, backup_fname)
#      os.rename(tempName, file_path)


def process_file(dummy, current_dir, file_list):
   for child in file_list:
#      if "pd.html" == child:
      if re.search(r".+\.html$", child, re.U) and os.path.isfile(current_dir + "/" + child):
         replace_string_in_file(current_dir + "/" + child)

os.path.walk(input_dir, process_file, "dummy")

print "Done."
