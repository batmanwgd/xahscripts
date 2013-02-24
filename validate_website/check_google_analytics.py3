# -*- coding: utf-8 -*-
# Python 3

# 2013-02-16
# validate all xahsite's Google analytics tag
# XahLee.org

# for each file in dir, check if the file contains one and only one google analytics string, with correct id

import re
import os
import sys

inPath = "/home/xah/web/xahlee_info/comp"
inPath = "/home/xah/web/"

gaIdTable = {
'ergoemacs_org': 'UA-10884311-3',
'wordyenglish_com': 'UA-10884311-7',
'xaharts_org': 'UA-10884311-9',
'xahlee_info': 'UA-10884311-1',
'xahlee_org': 'UA-10884311-2',
'xahmusic_org': 'UA-10884311-8',
'xahporn_org': 'UA-10884311-6',
'xahsl_org': 'UA-10884311-10'
}

googleAnalyticsCodeTemplate = r"""<script>var _gaq = _gaq || []; _gaq.push(['_setAccount', '•']); _gaq.push(['_trackPageview']); (function() { var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true; ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s); })();</script>"""

def getId(fPath):
    """Return the Google Analytics id string of a xahsite corresponding to fPath."""
    id = ""
    for kk, vv in gaIdTable.items():
        mObj = re.search(kk, fPath)
        if mObj:
            id = vv
            break
    if id == "":
        sys.stderr.write("Error: can't find domain for file 「{}」".format(fPath))
        sys.exit(2)
    else:
        return id

def check_google_analytics(fPath):
    """Print the fPath if it doesn't have the correct Google Analytics code."""

    # ignore files.
    if re.search("/xx", fPath) or re.search("xahlee_info/js/ex/", fPath):
        return "ignore"

    ii = 0
    idStr = getId(fPath)
    searchStr = re.sub("•", idStr, googleAnalyticsCodeTemplate)
    # print("「{}」".format(searchStr))
    myFile = open(fPath, "r")
    for aLine in myFile:
        # ignore if first line is <meta http-equiv="refresh" content="0
        if re.search(r'^<meta http-equiv="refresh" content="0', aLine):
            return "ignore"
        if aLine.rstrip() == searchStr:
            ii += 1
    myFile.close()
    if ii != 1:
        print("• {0} {1}".format(ii, fPath))

##################################################
# main

# get rid of trailing slash. not needed in python 3
# while inPath[-1] == '/': inPath = inPath[0:-1]

# report if the input path doesn't exist
if (not os.path.exists(inPath)):
    sys.stderr.write("Error: input path 「{}」 doesn't exist!".format(inPath))
    sys.exit(1)

# traverse the dir, call check_google_analytics() on the file
for dpath, dirList, fileList in os.walk(inPath):
    for fname in fileList:
        if re.search("\.html$", fname):
            fileFullPath = os.path.join(dpath, fname)
            check_google_analytics(fileFullPath)

print("Done. Errors are printed above, if any.")
