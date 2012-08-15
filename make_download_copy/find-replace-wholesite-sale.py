# -*- coding: utf-8 -*-
# Python

# find & replace strings in a dir

import os,sys,shutil,re

# if this this is not empty, then only these files will be processed
my_files  = [
# "/cygdrive/c/Users/h3/web/xahlee_org/Periodic_dosage_dir/t1/20040505_unicode.html",
# "/cygdrive/c/Users/h3/web/xahlee_org/Periodic_dosage_dir/bangu/typography.html",
]

input_dir = "/cygdrive/c/Users/h3/web/ooo"

min_level = 1; # files and dirs inside input_dir are level 1.
max_level = 7; # inclusive

print_no_change = False

find_replace_list = [

(
u'''<script>var _gaq = _gaq || []; _gaq.push(['_setAccount', 'UA-10884311-2']); _gaq.push(['_trackPageview']); (function() { var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true; ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s); })();</script>
</head>''',
u'''</head>''',
),

(u'''<div class="hdζ"><span class="σ">∑</span> <a href="http://xahlee.org/index.html">Home</a> ◇ <a href="http://xahlee.org/Periodic_dosage_dir/cmaci_girzu.html">Math</a> ◇ <a href="http://xahlee.org/Periodic_dosage_dir/skami_prosa.html">Computing</a> ◇ <a href="http://xahlee.org/arts/index.html">Arts</a> ◇ <a href="http://xahlee.org/PageTwo_dir/Vocabulary_dir/vocabulary.html">Words</a> ◇ <a href="http://xahlee.org/Periodic_dosage_dir/t2/mirrored.html">Literature</a> ◇ <a href="http://xahlee.org/music/index.html">Music</a> ◆ <a href="http://twitter.com/xah_lee" target="_top"><img src="http://twitter.com/favicon.ico" alt="twitter"></a> <a href="http://www.facebook.com/xahlee" target="_top"><img src="http://xahlee.org/ics/fb3.png" alt="facebook"></a> <a href="http://gplus.to/xah" target="_top"><img src="http://xahlee.org/ics/gp.png" alt="g+"></a> <a href="http://xahlee.blogspot.com/feeds/posts/default" target="_top"><img src="http://xahlee.org/ics/wf.png" alt="webfeed"></a></div>''',
u''),

(
u'''<div id="cse" style="width: 100%;"></div>
<script src="http://www.google.com/jsapi"></script>
<script>google.load('search', '1', {language : 'en'}); google.setOnLoadCallback(function() { var customSearchControl = new google.search.CustomSearchControl('011457790424202083459:4gyr8njd5kg'); customSearchControl.setResultSetSize(google.search.Search.FILTERED_CSE_RESULTSET); customSearchControl.draw('cse'); }, true);</script>''',
u'',
),

(
u'''<div class="chtk"><script>ch_client="polyglut";ch_width=550;ch_height=90;ch_type="mpu";ch_sid="Chitika Default";ch_backfill=1;ch_color_site_link="#00C";ch_color_title="#00C";ch_color_border="#FFF";ch_color_text="#000";ch_color_bg="#FFF";</script><script src="http://scripts.chitika.net/eminimalls/amm.js"></script></div>''',
u'',
),

(
u'''<script charset="utf-8" src="http://ws.amazon.com/widgets/q?rt=tf_sw&ServiceVersion=20070822&MarketPlace=US&ID=V20070822/US/xahhome-20/8002/2aa120d1-c3eb-48eb-99d2-da30d030258e"></script>''',
u'',
),

(
u'''<div class="¤xd"><a href="http://xahlee.org/ads.html">Advertise Here</a></div>''',
u'',
),

(
u'''<script><!--
amazon_ad_tag = "xahh-20"; amazon_ad_width = "728"; amazon_ad_height = "90"; amazon_ad_logo = "hide"; amazon_color_border = "7E0202";//--></script>
<script src="http://www.assoc-amazon.com/s/ads.js"></script>''',
u'',
),

(
u'''<div id="disqus_thread"></div><script>(function(){var dsq=document.createElement('script');dsq.type='text/javascript';dsq.async=true;dsq.src='http://xahlee.disqus.com/embed.js';(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);})();</script><a href="http://disqus.com" class="dsq-brlink">blog comments powered by <span class="logo-disqus">Disqus</span></a>''',
u'',
),


(
u'''<iframe src="http://xahlee.org/footer.html" width="100%" frameborder="0"></iframe>''',
u'',
),

(
u'''<div class="¤"><a href="http://ode-math.com/" rel="nofollow">Differential Equations, Mechanics, and Computation</a></div>''',
u'',
),

(
u'''<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>''',
u'',
),

(
u'''<script src="http://xahlee.org/xlomain.js"></script>''',
u'',
),

(
u'''


''',
u'''
''',
),

]

def replace_string_in_file(file_path):
   "Replaces all findStr by repStr in file file_path"
   temp_fname = file_path+'~lc~'
   backup_fname = file_path+'~bk~'

   # print 'reading:', file_path
   input_file = open(file_path,'rb')
   file_content = unicode(input_file.read(),'utf-8')
   input_file.close()

   num_replaced = 0
   for a_pair in find_replace_list:
      num_replaced += file_content.count(a_pair[0])
      output_text = file_content.replace(a_pair[0],a_pair[1])
      file_content = output_text

   if num_replaced > 0:
      print 'modified: ', num_replaced, ' ', file_path
      shutil.copy2(file_path,backup_fname)
      output_file = open(file_path,'r+b')
      output_file.read() # we do this way to preserve file creation date
      output_file.seek(0)
      output_file.write(output_text.encode('utf-8'))
      output_file.truncate()
      output_file.close()
   else:
      if print_no_change == True:
         print 'no change:', file_path

#      os.remove(file_path)
#      os.rename(temp_fname,file_path)

def process_file(dummy, curdir, file_list):
   current_dir_level = len(re.split('/',curdir))-len(re.split('/',input_dir))
   cur_file_level = current_dir_level+1
   if min_level <= cur_file_level <= max_level:
      for a_file in file_list:
         if re.search(r'\.html$', a_file,re.U) and os.path.isfile(curdir + '/' + a_file):
            replace_string_in_file(curdir + '/' + a_file)

# remove ending slash
if input_dir.endswith("/"): input_dir = input_dir[0:-1]

if (len(my_files) != 0):
   for my_file in my_files: replace_string_in_file(my_file)
else:
   os.path.walk(input_dir, process_file, 'dummy')

print "Done."
