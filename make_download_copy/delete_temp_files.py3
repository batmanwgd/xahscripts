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

print(inPath)

# ##################################################
# # main

# report if the input path doesn't exist
if (not os.path.exists(inPath)):
    sys.stderr.write("Error: input path 「{}」 doesn't exist!".format(inPath))
    sys.exit(1)



# traverse the dir, remove temp files
for dpath, dirList, fileList in os.walk(inPath, topdown=False):
    for ff in fileList:
        if (ff == ".htaccess") or \
                (ff == ".DS_Store") or \
                re.search(r"^xx", ff) or \
                re.search(r"^#.+#$", ff) or \
                re.search(r"~$", ff) or \
                re.search(r"^xx", ff):
            print("◆", ff)
            os.remove(ff)

# traverse the dir, remove temp dirs
for dpath, dirList, fileList in os.walk(inPath, topdown=False):
    # print(dpath)
    if re.search(r"/xx", dpath):
        print("•", dpath)
        shutil.rmtree(dpath)

