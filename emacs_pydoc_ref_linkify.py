# -*- coding: utf-8 -*-

# input: stdin and 1st arg from command line
# output: stdout

# input is a file path, like this:
# /home/xah/web/xahlee_info/python_doc_2.7.6/library/stdtypes.html#mapping-types-dict
# first arg is a file path like this
# /home/xah/web/xahlee_info/python/python3_traverse_dir.html
# output should be like this

# <span class="ref"><a href="../python_doc_2.7.6/library/stdtypes.html#mapping-types-dict">5. Built-in Types — Python v2.7.6 documentation #mapping-types-dict</a></span>

# the path is a relative path, relative to script arg. The link text is from the file's title, plus the fragment url, if any

# this is called by a emacs command python-ref-linkify

# Xah Lee
# http://xahlee.info/
# 2013-11-29

import sys
import os.path
import re

default_input = "/home/xah/web/xahlee_info/python_doc_3.3.3/library/os.html#os.walk"
default_bufferpath = "/home/xah/web/xahlee_info/python/python3_traverse_dir.html"

input_text = sys.stdin.read()
input_text = default_input if input_text == "" else input_text

buffer_path = sys.argv[1] if len(sys.argv) == 2 else default_bufferpath

########################

input_text = re.sub(r"^file://", "" , input_text.strip())

if re.search(r"#", input_text):
    doc_path, frac = input_text.split("#")
else:
    doc_path, frac = input_text, ""

doc_title = ""

with open(doc_path, "r") as f1:
    for xline in f1:
        xmatch = re.search(r"<title>([^<]+?)</title>", xline, re.UNICODE)
        # <title>16.1. os — Miscellaneous operating system interfaces — Python v3.3.3 documentation</title>
        if xmatch:
            doc_title = xmatch.group(1)
            break

# if doc_title == "":
#     sys.exit("no title found in 「{}」".format(doc_path))

relative_path = os.path.relpath( doc_path, start= os.path.dirname(buffer_path))

print("""<span class="ref"><a href="{}">{}</a></span>""".format(relative_path + "#" + frac, doc_title + " #" + frac) )
