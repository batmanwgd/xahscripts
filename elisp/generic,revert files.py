# -*- coding: utf-8 -*-
# python
# 2012-06-07
# revert a list of files. If a file path is xyz, then revert from the file xyz~ (or other suffix)

import os, shutil

myFileList = [
"c:/Users/h3/web/ergoemacs_org/index.html",
"c:/Users/h3/web/ergoemacs_org/ErgoEmacs_faq.html",

]

for ff in myFileList:
    fromName = ff + "~gr~"
    print ff
    # os.rename(fromName, ff)
    shutil.copy(fromName, ff)
