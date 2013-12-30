#!/usr/bin/python3
# -*- coding: utf-8 -*-

# input: stdin and 1st arg from command line
# output: stdout

# input is a file path, like this:
# /home/xah/web/xahlee_info/python_doc_2.7.6/library/stdtypes.html#mapping-types-dict
# first arg is a file path like this
# /home/xah/web/xahlee_info/python/python3_traverse_dir.html
# output should be like this
#
# <span class="ref"><a href="../python_doc_2.7.6/library/stdtypes.html#mapping-types-dict">5. Built-in Types — Python v2.7.6 documentation #mapping-types-dict</a></span>
#
# the path is a relative path, relative to script arg. The link text is from the file's title, plus the fragment url, if any
#
# this is called by a emacs command python-ref-linkify
#
# Author:
# Xah Lee
# http://xahlee.info/
# 2013-11-29
# Updated by:
# Anler Hp
# 2013-11-30

import sys
import os.path
import re
import mmap
import argparse

default_input = "/home/xah/web/xahlee_info/python_doc_3.3.3/library/os.html#os.walk"
default_bufferpath = "/home/xah/web/xahlee_info/python/python3_traverse_dir.html"
title_regex = re.compile(b"<title>([^<]+?)</title>")
charset_regex = re.compile(b'charset="([^"]+?)"')

def strip_file_protocol(string, default=""):
    return re.sub(r"^file://", "", string.strip()) or default

def split(string):
    try:
        doc_path, frac = string.split("#")
    except ValueError:
        doc_path, frac = string, ""
    return doc_path, frac

def find_charset(html, default_charset="utf-8"):
    match = charset_regex.search(html)
    charset = match.group(1).decode() if match else default_charset
    return charset

def find_title(html, encoding=None):
    match = title_regex.search(html)
    title = match.group(1).decode(encoding) if match else ""
    return title

def main(argv=None):
    if argv is None:
        argv = sys.argv[1:]
    parser = argparse.ArgumentParser()
    parser.add_argument("buffer_path", nargs="?", default=default_bufferpath)

    args = parser.parse_args(argv)

    buffer_path = args.buffer_path
    input_text = strip_file_protocol(sys.stdin.read(), default=default_input)

    doc_path, frac = split(input_text)

    with open(doc_path, "r+") as f:
        html = mmap.mmap(f.fileno(), 0)
        doc_title = find_title(html, encoding=find_charset(html))

    # if not doc_title:
    #     print("no title found in 「{}」".format(doc_path), file=sys.stderror)
    #     return 1

    relative_path = os.path.relpath(doc_path, start=os.path.dirname(buffer_path))

    tpl = """<span class="ref"><a href="{}">{}</a></span>"""
    link = "#".join((relative_path, frac))
    title = "#".join((doc_title, frac))

    print(tpl.format(link, title))

if __name__ == "__main__":
    sys.exit(main())
