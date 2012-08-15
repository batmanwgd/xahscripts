# -*- coding: utf-8 -*-
# Python

# split chapters
# split a file into several files, by a regex as delimiter. This
# is used to split classical novels in html into one file per
# chapter/section. XahLee.org , 2005-06

import re

inFilePath='/Users/xah/web/p/alice/y/x.html'
outDir='/Users/xah/web/p/alice'

patt ='<h1>CHAPTER '

pretext=u'''<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta HTTP-EQUIV="Content-Type" CONTENT="text/html;charset=utf-8">
<meta http-equiv="Content-Language" content="en">
<meta name="keywords" content="literature, Lewis Carroll, adventure, fairy tale">
<title>Xah: Alice's Adventures in Wonderland</title>
<link rel="StyleSheet" href="alice.css" type="text/css">
</head>
<body>
'''

posttext=u'''
<hr>
<pre>http://xahlee.org/p/alice/alice.html
© copyright 2006 by <a href="http://xahlee.org/PageTwo_dir/more.html">Xah Lee</a>. (<a href="mailto:xah%40xahlee.org">xah&#64;xahlee.org</a>)</pre>
<p align="center"><img src="../../Icons_dir/icon_sum.gif" width="32" height="32" alt="Xah Lee's Signet"></p>
</body>
</html>
'''

inF = open(inFilePath,'rb')
s=unicode(inF.read(),'utf-8')
inF.close()

chaps=re.split(patt, s)

for m in range(1,len(chaps)):
    chp_prev=m-1
    chp_current=m
    chp_next=m+1
    fileName=outDir + '/' + 'alice-ch%02i.html' % (m)

    nav_text= u'''<pre class="nav">★ <a href="alice-ch%02i.html">◀</a> <a href="alice.html">▲</a> <a href="alice-ch%02i.html">▶</a></pre>''' %(chp_prev,chp_next)

    if (chp_current == 1):
        nav_text= u'''<pre class="nav">★ <a href="alice.html">▲</a> <a href="alice-ch%02i.html">▶</a></pre>''' %(chp_next)

    if (chp_current == len(chaps)-1):
        nav_text= u'''<pre class="nav">★ <a href="alice-ch%02i.html">◀</a> <a href="alice.html">▲</a></pre>''' %(chp_prev)

    title_text=u'''<pre>Alice's Adventures in Wonderland</pre>'''

    outF = open(fileName,'wb')
    outtext=pretext + nav_text + u"\n" + title_text + patt + chaps[m] + nav_text + posttext
    outF.write(outtext.encode('utf-8'))
    outF.close()

