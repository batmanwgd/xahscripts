# -*- coding: utf-8 -*-
# Python 3

# find & replace strings in a dir

import os, sys, shutil, re
import datetime

# if this this is not empty, then only these files will be processed
file_list = [
]

# directory to skip
dir_ignore = [

"REC-SVG11-20110816",
"REC-SVG11-20110816",
"clojure-doc-1.6",
"css3_spec_bg",
"css_2.1_spec",
"css_3_color_spec",
"css_transitions",
"dom-whatwg",
"html5_whatwg",
"java8_doc",
"javascript_ecma-262_5.1_2011",
"javascript_ecma-262_5.1_2011",
"javascript_ecma-262_6_2015",
"javascript_es6",
"jquery_doc",
"node_api",
"php-doc",
"python_doc_2.7.6",
"python_doc_3.3.3",

]

input_dir = sys.argv[1]
print(input_dir)

input_dir = os.path.normpath(input_dir)

min_level = 1 # files and dirs inside input_dir are level 1.
max_level = 7 # inclusive

print_filename_when_no_change = False

# • remember to remove js/ex dir
# • many pages don't have double ads

find_replace_list = [

    # emacs site

('''<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
ga('create', 'UA-10884311-3', 'auto');
ga('send', 'pageview');
</script>''',
''),

('''• <a class="buyxahemacs36183" href="http://ergoemacs.org/emacs/buy_xah_emacs_tutorial.html">Buy Xah Emacs Tutorial</a>''',
''),

('''<p>or, buy something from my <a class="sorc" href="http://astore.amazon.com/xahhome-20" data-accessed="2016-06-30">keyboard store</a>.</p>''',
''),

('''<iframe src="http://astore.amazon.com/xahhome-20" width="90%" height="900" frameborder="0" scrolling="no"></iframe>''',
''),

('''<div class="buyxahemacs97449">Like it? <a href="buy_xah_emacs_tutorial.html">Buy Xah Emacs Tutorial</a>. <span style="color:red;font-size:xx-large">♥</span> Thanks.</div>''',
''),

('''• <a href="https://twitter.com/ErgoEmacs">Follow me on Twitter</a>
• <a href="https://plus.google.com/113859563190964307534/posts">Follow me on g+</a>
• <a class="rss_feed_xl" href="blog.xml">Subscribe Feed</a>''',
''),

    # #####################################

('''<a href="http://xahlee.info/index.html"><span class="xsignet">∑</span><span class="xsignetxah">XAH</span></a>''',
''),

('''<iframe src="http://astore.amazon.com/xahmath-20" width="90%" height="900" frameborder="0" scrolling="no"></iframe>''',
''),

('''<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
ga('create', 'UA-10884311-1', 'auto');
ga('send', 'pageview');
</script>''',
''),

(
'''<div class="xgcse"><script>(function(){var cx='partner-pub-5125343095650532:1853288892';var gcse=document.createElement('script');gcse.async=true;gcse.src='//www.google.com/cse/cse.js?cx='+cx;var s=document.getElementsByTagName('script')[0];s.parentNode.insertBefore(gcse,s);})();</script><gcse:searchbox-only></gcse:searchbox-only></div>''',
''
),

(
'''<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- side300x600 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:300px;height:600px"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="7031204381"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>''',
''
),

('''<div class="buy_xahleeinfo_37204">
Download xahlee.info.
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_xclick">
<input type="hidden" name="business" value="JPHAB7F7QZRPC">
<input type="hidden" name="lc" value="US">
<input type="hidden" name="item_name" value="xahlee.info content">
<input type="hidden" name="amount" value="49.00">
<input type="hidden" name="currency_code" value="USD">
<input type="hidden" name="button_subtype" value="services">
<input type="hidden" name="no_note" value="0">
<input type="hidden" name="cn" value="Add special instructions to the seller:">
<input type="hidden" name="no_shipping" value="1">
<input type="hidden" name="bn" value="PP-BuyNowBF:btn_buynowCC_LG.gif:NonHosted">
<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
</form>
</div>''',
''),

(
'''<div class="ad66704">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- autosize20160323 -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="5724977989"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>''',
''
),

(
'''<div class="google-recommend-content-64663">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- google recommended content -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="6356170789"
     data-ad-format="autorelaxed"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>''',
''
),

(
'''<div class="ads-bottom-65900">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- autosize20160323 -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="5724977989"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>''',
''
),

(
'''<div id="disqus_thread"></div><script>(function(){var dsq=document.createElement('script');dsq.async=true;dsq.src='//xahlee.disqus.com/embed.js';(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);})();</script>''',
''
),

(
'''<div class="buy-js-33416">Like what you read? <a href="buy_xah_js_tutorial.html">Buy JavaScript in Depth</a>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick" />
<input type="hidden" name="hosted_button_id" value="J3BC865C77JUC" />
<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!" />
<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1" />
</form>
<span style="font-size:4rem;color:red">♥</span>
or, buy a new keyboard, see <a href="http://xahlee.info/kbd/keyboard_review_gallery.html">Keyboard Reviews</a>.</div>''',
''

),

(
    # 2016-05-22 new. page level ads
'''<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<script>
  (adsbygoogle = window.adsbygoogle || []).push({
    google_ad_client: "ca-pub-5125343095650532",
    enable_page_level_ads: true
  });
</script>''',
''
),

    # 2016-07-09 new. just 1 page auto resize ad test at /js/html_index.html
('''<div class="ads-05316">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- autosize20160628 -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="5936138388"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>''',
''
),

]


regex_pairs_list = [

(re.compile(r'''<nav id="nav-top-04391">\n+</nav>''', re.U|re.M|re.DOTALL), ''),

(re.compile(r'''<aside id="aside-right-89129">\n+</aside>''', re.U|re.M|re.DOTALL), ''),

]



for x in find_replace_list:
    if len(x) != 2:
        sys.exit("Error: replacement pair has more than 2 elements. Probably missing a comma.")

def want_this_path(file_path, dir_ignore):
    "returns True if the file is wanted."
    for dir in dir_ignore:
        if (re.search(dir, file_path, re.U)):
            return False
    return True

def replace_string_in_file(file_path):
    "Replaces all findStr by repStr in file file_path"
    backup_fname = file_path + "~bk~"

    print ("reading:", file_path)
    input_file = open(file_path, "r", encoding="utf-8")
    file_content = input_file.read()
    input_file.close()

    num_replaced = 0
    for a_pair in find_replace_list:
        num_replaced += file_content.count(a_pair[0])
        file_content = file_content.replace(a_pair[0], a_pair[1])

    for a_pair in regex_pairs_list:
        tem_tuple = re.subn(a_pair[0], a_pair[1], file_content)
        file_content = tem_tuple[0]
        num_replaced += tem_tuple[1]

    if num_replaced > 0:
        print("◆ ", num_replaced, " ", file_path.replace(os.sep, "/"))
        # shutil.copy2(file_path, backup_fname)
        output_file = open(file_path, "w")
        output_file.write(file_content)
        output_file.close()
    else:
        if print_filename_when_no_change == True:
            print("no change:", file_path)

##################################################

print(datetime.datetime.now())
print("Input Dir:", input_dir)
for x in find_replace_list:
   print("Find string:「{}」".format(x[0]))
   print("Replace string:「{}」".format(x[1]))
   print("\n")

if (len(file_list) != 0):
   for ff in file_list: replace_string_in_file(os.path.normpath(ff) )
else:
    for dirPath, subdirList, fileList in os.walk(input_dir):
        curDirLevel = dirPath.count( os.sep) - input_dir.count( os.sep)
        curFileLevel = curDirLevel + 1
        if min_level <= curFileLevel <= max_level:
            for fName in fileList:
                if (re.search(r"\.html$", fName, re.U)) and want_this_path(dirPath, dir_ignore):
                    replace_string_in_file(dirPath + os.sep + fName)
                    # print ("level %d,  %s" % (curFileLevel, os.path.join(dirPath, fName)))

print("Done.")
