# -*- coding: utf-8 -*-
# Python

# find & replace strings in a dir

import os, sys, shutil, re
import datetime

# if this this is not empty, then only these files will be processed
my_files  = [

"c:/Users/h3/web/xahlee_info/comp/20031219_ants_systems.html",
"c:/Users/h3/web/xahlee_info/js/20031219_webrowsers.html",
"c:/Users/h3/web/xahlee_info/math/20031223_math_sim.html",
"c:/Users/h3/web/xahlee_info/math/20040104_trivia.html",
"c:/Users/h3/web/xahlee_info/comp/Neal_Stephenson.html",
"c:/Users/h3/web/xahlee_info/comp/industry_and_university.html",
"c:/Users/h3/web/xahlee_info/comp/is_philosophy_useful.html",
"c:/Users/h3/web/xahlee_info/comp/joule.html",
"c:/Users/h3/web/xahlee_info/w/monolithic_webpage.html",
"c:/Users/h3/web/xahlee_info/w/pirate_bay.html",
"c:/Users/h3/web/xahlee_info/comp/DVD_rip.html",
"c:/Users/h3/web/xahlee_info/w/google_search_drops_traffic.html",
"c:/Users/h3/web/xahlee_info/w/internet_world.html",
"c:/Users/h3/web/xahlee_info/w/webhosting.html",
"c:/Users/h3/web/xahlee_info/w/orkut_morsi.html",
"c:/Users/h3/web/xahlee_info/math/russel_tower.html",
"c:/Users/h3/web/xahlee_info/w/wikimorons.html",
"c:/Users/h3/web/xahlee_info/w/wikipedia_misinfo.html",

]

input_dir = "c:/Users/h3/web/xahlee_info/"


min_level = 1 # files and dirs inside input_dir are level 1.
max_level = 6 # inclusive

print_no_change = False

find_replace_list = [

(
u"""<script>var _gaq = _gaq || []; _gaq.push(['_setAccount', 'UA-10884311-2']); _gaq.push""",
u"""<script>var _gaq = _gaq || []; _gaq.push(['_setAccount', 'UA-10884311-1']); _gaq.push""",
),

(
u"""<link rel="stylesheet" href="http://xahlee.org/""",
u"""<link rel="stylesheet" href="../""",
),

(
u"""<body>""",
u"""<body>

<form action="http://www.google.com" id="cse-search-box"> <div> <input type="hidden" name="cx" value="partner-pub-5125343095650532:1853288892" /> <input type="hidden" name="ie" value="UTF-8" /> <input type="text" name="q" size="55" /> <input type="submit" name="sa" value="Search" /> </div> </form><script src="http://www.google.com/coop/cse/brand?form=cse-search-box&amp;lang=en"></script>""",
),

# <div class="nav"><a href="http://xahlee.info/comp/comp_index.html">Computing ＆ its People</a></div>
# <div class="nav"><a href="http://xahlee.org/Periodic_dosage_dir/purci_prosa_dikni.html">Women, WASP, Human Animals</a></div>


# (
# u"""<div class="nav"><a href="http://xahlee.org/Periodic_dosage_dir/purci_prosa_dikni.html">Women, WASP, Human Animals</a></div>""",
# u"""<div class="nav"><a href="../musing/bangu.html">Language ＆ English</a></div>"""),


# (
# u"""<div class="nav"><a href="http://xahlee.org/index.html">XahLee.org</a></div>""",
# u"""<div class="nav"><a href="../index.html">WordyEnglish.com</a></div>""",
# ),

(
u'''<div class="βds">
<script charset="utf-8" src="http://ws.amazon.com/widgets/q?rt=tf_sw&amp;ServiceVersion=20070822&amp;MarketPlace=US&amp;ID=V20070822/US/xahhome-20/8002/97c57146-4835-472a-a8d9-d43977e801f5"></script>
</div>''',

u'''<div class="βds">
<script><!--
google_ad_client = "pub-5125343095650532";
/* 728x90, created 8/12/09 */
google_ad_slot = "8521101965";
google_ad_width = 728;
google_ad_height = 90;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
</div>''',
),

(
u"""<script><!--
amazon_ad_tag = "xahh-20"; amazon_ad_width = "728"; amazon_ad_height = "90"; amazon_ad_logo = "hide"; amazon_color_border = "7E0202";//--></script>
<script src="http://www.assoc-amazon.com/s/ads.js"></script>""",

u'''<script><!--
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
)




# (
# u"""<form action="http://www.google.com" id="cse-search-box"> <div> <input type="hidden" name="cx" value="partner-pub-5125343095650532:5574213426" /> <input type="hidden" name="ie" value="UTF-8" /> <input type="text" name="q" size="55" /> <input type="submit" name="sa" value="Search" /> </div> </form> <script src="http://www.google.com/coop/cse/brand?form=cse-search-box&amp;lang=en"></script>

# <form action="http://www.google.com" id="cse-search-box"> <div> <input type="hidden" name="cx" value="partner-pub-5125343095650532:5574213426" /> <input type="hidden" name="ie" value="UTF-8" /> <input type="text" name="q" size="55" /> <input type="submit" name="sa" value="Search" /> </div> </form> <script src="http://www.google.com/coop/cse/brand?form=cse-search-box&amp;lang=en"></script>""",

# u"""<form action="http://www.google.com" id="cse-search-box"> <div> <input type="hidden" name="cx" value="partner-pub-5125343095650532:5574213426" /> <input type="hidden" name="ie" value="UTF-8" /> <input type="text" name="q" size="55" /> <input type="submit" name="sa" value="Search" /> </div> </form> <script src="http://www.google.com/coop/cse/brand?form=cse-search-box&amp;lang=en"></script>""",
# ),


]

for x in find_replace_list:
   if len(x) != 2:
      sys.exit("Error: replacement pair has more than 2 elements. Probably missing a comma.")

def replace_string_in_file(file_path):
   "Replaces all findStr by repStr in file file_path"
   temp_fname = file_path + "~lc~"
   backup_fname = file_path + "~bk~"

   # print "reading:", file_path
   input_file = open(file_path, "rb")
   file_content = unicode(input_file.read(), "utf-8")
   input_file.close()

   num_replaced = 0
   for a_pair in find_replace_list:
      num_replaced += file_content.count(a_pair[0])
      output_text = file_content.replace(a_pair[0], a_pair[1])
      file_content = output_text

   if num_replaced > 0:
      print "◆ ", num_replaced, u" ", file_path.replace(os.sep, "/")
      shutil.copy2(file_path, backup_fname)
      output_file = open(file_path, "r+b")
      output_file.read() # we do this way instead of “os.rename” to preserve file creation date
      output_file.seek(0)
      output_file.write(output_text.encode("utf-8"))
      output_file.truncate()
      output_file.close()
   else:
      if print_no_change == True:
         print "no change:", file_path

#      os.remove(file_path)
#      os.rename(temp_fname, file_path)

print datetime.datetime.now()
print u"Dir:", input_dir
for x in find_replace_list:
   print u"find:", x[0].encode("utf-8")
   print u"replace:", x[1].encode("utf-8")
   print

def process_file(dummy, current_dir, file_list):
   cur_dir_level = current_dir.count( os.sep) - input_dir.count( os.sep)
   cur_file_level = cur_dir_level + 1
   if min_level <= cur_file_level <= max_level:
      for fName in file_list:
         if (re.search(r"\.html$", fName, re.U)) and (os.path.isfile(current_dir + re.escape(os.sep) + fName)):
            replace_string_in_file(current_dir + os.sep + fName)
            # print ("%d %s" % (cur_file_level, (current_dir + os.sep + fName).replace(os.sep, "/")))

input_dir = os.path.normpath(input_dir)

if (len(my_files) != 0):
   for my_file in my_files: replace_string_in_file(os.path.normpath(my_file) )
else:
   os.path.walk(input_dir, process_file, "dummy")

print "Done."
