# -*- coding: utf-8 -*-
# Python

# 2010
# find & replace strings in a dir
# specifically, replace paypal donation box by Google AdSense, and replace Google Analytics code.
# this script is called by another.

import os,sys,shutil,re

mydir= "C:/Users/xah/web/xahlee_info"; # end in slash ok. Better not.
minLevel=1; # files and dirs inside mydir are level 1.
maxLevel=6; # inclusive

findreplace = [
(

u'''<div class="dnt0c7af">Was this page useful? If so, please do donate $3, thank you <a href="http://xahlee.org/thanks.html">donors!</a><form action="https://www.paypal.com/cgi-bin/webscr" method="post"><div><input type="hidden" name="cmd" value="_s-xclick"><input type="hidden" name="hosted_button_id" value="8127788"><input type="image" src="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" name="submit"><img alt="" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1"></div></form></div>''',

u'''<script type="text/javascript"><!--
google_ad_client = "pub-5125343095650532";
/* 728x90, created 8/12/09 */
google_ad_slot = "8521101965";
google_ad_width = 728;
google_ad_height = 90;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>'''
),

(
u'''['_setAccount', 'UA-10884311-2']''',
u'''['_setAccount', 'UA-10884311-1']''',
),

(
u'''<div class="ftr"><div class="sig"></div><div class="x10"><a href="http://xahlee.org/">Home</a></div><div class="x20"><a href="http://xahlee.org/terms.html">Terms of Use</a></div><div class="x30"><a href="http://xahlee.org/about.html">About</a></div><div class="x40"><a href="http://xahlee.org/ads.html">Advertise</a></div><div class="x50"><a href="http://xahlee.org/subscribe.html">Subscribe</a></div><div class="x60"><form method="get" action="http://www.google.com/custom"><div><a href="http://www.google.com/"><img src="http://www.google.com/uds/css/small-logo.png" alt="Google"></a><input type="hidden" name="domains" value="xahlee.org"><input type="text" name="q" size="31" maxlength="255" value=""><input type="submit" name="sa" value="Search"><input type="hidden" name="sitesearch" value="xahlee.org"><input type="hidden" name="forid" value="1"><input type="hidden" name="ie" value="UTF-8"><input type="hidden" name="oe" value="UTF-8"><input type="hidden" name="cof" value="GALT:#008000;GL:1;DIV:#336699;VLC:663399;AH:center;BGC:FFFFFF;LBGC:336699;ALC:0000FF;LC:0000FF;T:000000;GFNT:0000FF;GIMP:0000FF;FORID:1;"><input type="hidden" name="hl" value="en"></div></form></div></div>''',

u'''<div class="ftr"><div class="sig"></div><div class="x10"><a href="http://xahlee.info/">Home</a></div><div class="x20"><a href="http://xahlee.info/terms.html">Terms of Use</a></div><div class="x30"><a href="http://xahlee.info/about.html">About</a></div><div class="x40"><a href="http://xahlee.info/ads.html">Advertise</a></div><div class="x50"><a href="http://xahlee.info/subscribe.html">Subscribe</a></div><div class="x60"><form method="get" action="http://www.google.com/custom"><div><a href="http://www.google.com/"><img src="http://www.google.com/uds/css/small-logo.png" alt="Google"></a><input type="hidden" name="domains" value="xahlee.info"><input type="text" name="q" size="31" maxlength="255" value=""><input type="submit" name="sa" value="Search"><input type="hidden" name="sitesearch" value="xahlee.info"><input type="hidden" name="forid" value="1"><input type="hidden" name="ie" value="UTF-8"><input type="hidden" name="oe" value="UTF-8"><input type="hidden" name="cof" value="GALT:#008000;GL:1;DIV:#336699;VLC:663399;AH:center;BGC:FFFFFF;LBGC:336699;ALC:0000FF;LC:0000FF;T:000000;GFNT:0000FF;GIMP:0000FF;FORID:1;"><input type="hidden" name="hl" value="en"></div></form></div></div>''',
),

]

def replaceStringInFile(filePath):
   "replaces all findStr by repStr in file filePath"
   tempName=filePath+'~x~'
   backupName=filePath+'~fr~'

   inF = open(filePath,'rb')
   s=unicode(inF.read(),'utf-8')
   inF.close()

   numRep=0
   for couple in findreplace:
      numRep += s.count(couple[0])
      outtext=s.replace(couple[0],couple[1])
      s=outtext

   if numRep > 0:
      print 'modified:', filePath
#      shutil.copy2(filePath,backupName)
      outF = open(filePath,'r+b')
      outF.read() # we do this way to preserve file creation date
      outF.seek(0)
      outF.write(outtext.encode('utf-8'))
      outF.truncate()
      outF.close()
   else:
      print 'no change:', filePath

def travelFun(dummy, curdir, filess):
   curdirLevel=len(re.split('/',curdir))-len(re.split('/',mydir))
   filessLevel=curdirLevel+1
   if minLevel <= filessLevel <= maxLevel:
      for child in filess:
         if re.search(r'\.html$',child,re.U) and os.path.isfile(curdir+'/'+child):
            replaceStringInFile(curdir+'/'+child)

os.path.walk(mydir, travelFun, 'dummy')

print "Done."
