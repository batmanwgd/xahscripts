# -*- coding: utf-8 -*-
# Python

import os,sys,shutil

# add navigation links to next/previosu chapter.
# Fri Jul  8 07:32:47 PDT 2005

mydir= '/Users/t/web/p/um2'
outdir= '/Users/t/web/p/um'

for nn in range(1,27+1):
   fn="um-s%02d.html"%(nn)
   infilePath=mydir + '/' + fn
   outfilePath=outdir + '/' + fn

   pre_fn="um-s%02d.html"%((nn+27-2)%27+1)
   next_fn="um-s%02d.html"%((nn+27)%27+1)
   top_fn="um.html"

   navtext=u'''<pre class="nav">★ <a href="''' + pre_fn + u'''">←</a> <a href="''' + top_fn + u'''">↑</a> <a href="'''+ next_fn + u'''">→</a></pre>'''

   text1='''<hr style="clear:both">'''
   text2= text1 + '\n' + navtext 

   text3=u'''<pre>★ back to <a href="um.html">Table of Contents</a></pre>'''
   text4= '\n' + navtext

   print 'reading:', infilePath
   inF = open(infilePath,'rb')
   s=unicode(inF.read(),'utf-8')
   inF.close()

   s=s.replace(text1,text2)
   s=s.replace(text3,text4)
   outtext=s

   print ' writing:', outfilePath
   outF = open(outfilePath,'wb')
   outF.write(outtext.encode('utf-8'))
   outF.close()
