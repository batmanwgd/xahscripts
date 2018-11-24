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

##################################################
    # all sites

##################################################
    # xahlee.info


    # 2018-08-10
('''<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({
          google_ad_client: "ca-pub-5125343095650532",
          enable_page_level_ads: true
     });
</script>''',
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

('''<div class="google_ad_right_30226">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- xlinfo_right_autosize_20171107 -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="9711764997"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>''',
''),

('''<div class="ad_top_39054">
<div class="google_ad_top_29890">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- xlinfo_top_autosize_20171107 -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="2984018199"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
</div>''',
''),

('''<div class="ads-bottom-65900">
<div class="google_ad_bottom_e7e59">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- xlinfo_ad_bottom_20171117 -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="4412368092"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
</div>''',
''),

(
'''<div class="buy-js-33416">
Liket it? Put $5 at
<a class="sorc" href="https://www.patreon.com/xahlee" data-accessed="2017-08-01">patreon</a>.<br />
<br />
Or, <a href="buy_xah_js_tutorial.html">Buy JavaScript in Depth</a>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_xclick" />
<input type="hidden" name="business" value="JPHAB7F7QZRPC" />
<input type="hidden" name="lc" value="US" />
<input type="hidden" name="item_name" value="xah JavaScript in Depth" />
<input type="hidden" name="amount" value="29.00" />
<input type="hidden" name="currency_code" value="USD" />
<input type="hidden" name="button_subtype" value="services" />
<input type="hidden" name="no_note" value="0" />
<input type="hidden" name="cn" value="Add special instructions to the seller:" />
<input type="hidden" name="no_shipping" value="1" />
<input type="hidden" name="shipping" value="0.00" />
<input type="hidden" name="bn" value="PP-BuyNowBF:btn_buynowCC_LG.gif:NonHosted" />
<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal" />
</form>
</div>''',
''
),

##################################################
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


('''<div class="ggl_ads_1wybm">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- google_ads_emacs_right_n6fhr -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="2962698824"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>''',''),

('''<div class="ad_top_39054">
<div class="ggl_ad_xfgrj">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- emacs_ad_top_86b9e -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="4897106337"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
</div>''',''),

('''<div class="ads-bottom-65900">
<div class="google_ads_emacs_bottom_98ade">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- xah_emacs_bottom_f82a5 -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="4157217227"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
</div>''',''),

(
'''<div class="buyxahemacs97449">
Patreon me $5
<a class="sorc" href="https://www.patreon.com/xahlee" data-accessed="2017-08-01">patreon</a>
<br /><br />
Or <a href="http://ergoemacs.org/emacs/buy_xah_emacs_tutorial.html">Buy Xah Emacs Tutorial</a>
<br /><br />
Or buy a nice keyboard:
<a href="http://ergoemacs.org/emacs/emacs_best_keyboard.html">Best Keyboard for Emacs</a>
</div>''',
''
),

('''<div class="ask_68256"><p>If you have a question, put $5 at <a class="sorc" href="https://www.patreon.com/xahlee" data-accessed="2017-08-01">patreon</a> and message me.</p></div>''',''),

    # #####################################

(
'''<div id="disqus_thread"></div>
<script>
(function() {
var d = document, s = d.createElement('script');
s.src = 'https://xahlee.disqus.com/embed.js';
s.setAttribute('data-timestamp', +new Date());
(d.head || d.body).appendChild(s);
})();
</script>''',
''
),

('''<div class="ask_68256">
<p>Ask me question on <a class="sorc" href="https://www.patreon.com/xahlee" data-accessed="2017-08-01">patreon</a></p>
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
    try:
        file_content = input_file.read()
    except UnicodeDecodeError:
        # print("UnicodeDecodeError:{:s}".format(input_file))
        return
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
