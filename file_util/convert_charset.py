# -*- coding: utf-8 -*-
# python

# 2005-03-07
# http://xahlee.info/perl-python/charset_encoding.html

# Note: better is the “iconv” util on linux.

import os

mydir= "/Users/t/web/_tp/wiki"

fromCharset="iso-8859-1"
toCharset="utf-8"

# utf-16

def changeEncoding(filePath):
    """take a full path to a file as input, and change its encoding from gb18030 to utf-16"""
    print filePath

    tempName=filePath+"~-~"

    input = open(filePath,"rb")
    content=unicode(input.read(),fromCharset)
    input.close()

    output = open(tempName,"wb")
    output.write(content.encode(toCharset))
    output.close()

    os.rename(tempName,filePath)


def myfun(dummy, dirr, filess):
    for child in filess:
        if ".html" == os.path.splitext(child)[1] and os.path.isfile(dirr+"/"+child):
            changeEncoding(dirr+"/"+child)
os.path.walk(mydir, myfun, "dumb")
