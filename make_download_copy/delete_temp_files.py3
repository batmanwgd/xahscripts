# -*- coding: utf-8 -*-
# Python 3

# 2013-02-21
# delete dir starting with xx
# delete files starting with xx
# delete other temp files:
# .htaccess     apache shit
# .DS_Store     Mac shit
# …~      emacs backup
# #…#     emacs autosave

# XahLee.org

import re
import os
import sys
import shutil

inPath = sys.argv[1]
print( "Processing: ",inPath)

# ##################################################
# # main

# report if the input path doesn't exist
if (not os.path.exists(inPath)):
    sys.stderr.write("Error: input path 「{}」 doesn't exist!".format(inPath))
    sys.exit(1)

# traverse the dir, remove temp dirs
for dpath, dirList, fileList in os.walk(inPath, topdown=True):
    # print(dpath)
    if re.search(r"/xx$|/\.git$", dpath):
        print("deleting ", dpath)
        shutil.rmtree(dpath)

# traverse the dir, remove temp files
for dpath, dirList, fileList in os.walk(inPath, topdown=False):
    for ff in fileList:
        if (ff == ".htaccess") or \
                (ff == ".DS_Store") or \
                re.search(r"^xx", ff) or \
                re.search(r"^#.+#$", ff) or \
                re.search(r"~$", ff) or \
                re.search(r"^xx", ff):
            print("◆ rm ", dpath + "/" + ff)
            os.remove(dpath + "/" + ff)

