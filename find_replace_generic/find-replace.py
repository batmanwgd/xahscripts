# -*- coding: utf-8 -*-
# Python

# find & replace strings in a dir

import os, sys, shutil, re
import datetime

# if this this is not empty, then only these files will be processed
my_files  = [

]

input_dir = "c:/Users/h3/web"

min_level = 1 # files and dirs inside input_dir are level 1.
max_level = 6 # inclusive

print_no_change = False

find_replace_list = [

(
u"""<kbd>⇞ Page↑</kbd>""",
u"""<kbd>⇞ Page △</kbd>""",
),

(
u"""<kbd>Page ⇟</kbd>""",
u"""<kbd>⇟ Page ▽</kbd>""",
),




]

for x in find_replace_list:
   if len(x) != 2:
      sys.exit("Error: replacement pair has more than 2 elements. Probably missing a comma.")

def replace_string_in_file(file_path):
   "Replaces all findStr by repStr in file file_path"
   temp_fname = file_path + "~lc~"
   backup_fname = file_path + "~bk~"

   # print "reading:", file_path
   input_file = open(file_path, "rb")
   file_content = unicode(input_file.read(), "utf-8")
   input_file.close()

   num_replaced = 0
   for a_pair in find_replace_list:
      num_replaced += file_content.count(a_pair[0])
      output_text = file_content.replace(a_pair[0], a_pair[1])
      file_content = output_text

   if num_replaced > 0:
      print "◆ ", num_replaced, u" ", file_path.replace(os.sep, "/")
      shutil.copy2(file_path, backup_fname)
      output_file = open(file_path, "r+b")
      output_file.read() # we do this way instead of “os.rename” to preserve file creation date
      output_file.seek(0)
      output_file.write(output_text.encode("utf-8"))
      output_file.truncate()
      output_file.close()
   else:
      if print_no_change == True:
         print "no change:", file_path

#      os.remove(file_path)
#      os.rename(temp_fname, file_path)

print datetime.datetime.now()
print u"Dir:", input_dir
for x in find_replace_list:
   print u"find:", x[0].encode("utf-8")
   print u"replace:", x[1].encode("utf-8")
   print

def process_file(dummy, current_dir, file_list):
   cur_dir_level = current_dir.count( os.sep) - input_dir.count( os.sep)
   cur_file_level = cur_dir_level + 1
   if min_level <= cur_file_level <= max_level:
      for fName in file_list:
         if (re.search(r"\.html$", fName, re.U)) and (os.path.isfile(current_dir + re.escape(os.sep) + fName)):
            replace_string_in_file(current_dir + os.sep + fName)
            # print ("%d %s" % (cur_file_level, (current_dir + os.sep + fName).replace(os.sep, "/")))

input_dir = os.path.normpath(input_dir)

if (len(my_files) != 0):
   for my_file in my_files: replace_string_in_file(os.path.normpath(my_file) )
else:
   os.path.walk(input_dir, process_file, "dummy")

print "Done."