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
"clojure-doc-1.6/",
"css_2.1_spec/",
"css3_spec_bg/",
"css_transitions/",
"dom3-core/",
"dom3-load_save/",
"dom3-validation/",
"dom-whatwg/",
"git-bottomup/",
"javascript_ecma-262_5.1_2011/",
"jquery_doc/",
"node_api/",
"python_doc_2.7.6/",
"python_doc_3.3.3/",
"REC-SVG11-20110816/",
"webgl/",
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
(
   # google analytics tracker

"""<script>(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');ga('create','UA-10884311-3','ergoemacs.org');ga('send','pageview');</script>"""
,
""
),

("""<script>(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');ga('create','UA-10884311-1','xahlee.info');ga('require','displayfeatures');ga('send','pageview');</script>""",""),

("""<script charset="utf-8" type="text/javascript">
amzn_assoc_ad_type = "responsive_search_widget";
amzn_assoc_tracking_id = "xahhome-20";
amzn_assoc_marketplace = "amazon";
amzn_assoc_region = "US";
amzn_assoc_placement = "";
amzn_assoc_search_type = "search_widget";
amzn_assoc_width = "auto";
amzn_assoc_height = "auto";
amzn_assoc_default_search_category = "";
amzn_assoc_default_search_key = "";
amzn_assoc_theme = "light";
amzn_assoc_bg_color = "FFFFFF";
</script>
<script src="http://z-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&Operation=GetScript&ID=OneJS&WS=1&MarketPlace=US"></script>""",""),

("""<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- side300x600 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:300px;height:600px"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="7031204381"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>""", ""),

("""<div class="ad66704">
<script async src="http://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- 728x90, created 8/12/09 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:728px;height:90px"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="8521101965"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>""", ""),

("""<div class="pp93653">
Buy xahlee.info for offline reading.
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
</div>""",""),

("""<div class="ads-bottom-65900">
<script async src="http://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- 728x90, created 8/12/09 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:728px;height:90px"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="8521101965"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>""",""),

("""<div id="disqus_thread"></div><script>(function(){var dsq=document.createElement('script');dsq.type='text/javascript';dsq.async=true;dsq.src='http://xahlee.disqus.com/embed.js';(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);})();</script><a href="http://disqus.com" class="dsq-brlink">blog comments powered by <span class="logo-disqus">Disqus</span></a>""",""),

("""<script>(function() { var po=document.createElement('script');po.type='text/javascript';po.async=true;po.src='https://apis.google.com/js/plusone.js';var s=document.getElementsByTagName('script')[0];s.parentNode.insertBefore(po,s);})();</script>""",""),

("""<a href="https://twitter.com/xah_lee"> </a> <a href="https://plus.google.com/112757647855302148298"> </a> <a href="http://www.facebook.com/xahlee"> </a>""", ""),

("""<div id="share-buttons-97729"><div class="g-plusone" data-size="medium" data-annotation="none"></div></div><script defer src="share_widgets.js"></script>""",""),
("""<div id="share-buttons-97729"><div class="g-plusone" data-size="medium" data-annotation="none"></div></div><script defer src="../share_widgets.js"></script>""",""),
("""<div id="share-buttons-97729"><div class="g-plusone" data-size="medium" data-annotation="none"></div></div><script defer src="../../share_widgets.js"></script>""",""),
("""<div id="share-buttons-97729"><div class="g-plusone" data-size="medium" data-annotation="none"></div></div><script defer src="../../../share_widgets.js"></script>""",""),

("""<div class="paypal-donate-60910"><form action="https://www.paypal.com/cgi-bin/webscr" method="post"><input type="hidden" name="cmd" value="_s-xclick" /><input type="hidden" name="hosted_button_id" value="8127788" /><input type="image" src="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" name="submit" /><img src="https://www.paypal.com/en_US/i/scr/pixel.gif" alt="" width="1" height="1" /></form></div>""", ""),

("""<div class="ppp8745"><form action="https://www.paypal.com/cgi-bin/webscr" method="post"><input type="hidden" name="cmd" value="_s-xclick" /><input type="hidden" name="hosted_button_id" value="Y4V2F8TA949M2" /><input type="image" src="https://www.paypal.com/en_US/i/btn/btn_paynowCC_LG.gif" name="submit" alt="PayPal" /><img src="https://www.paypal.com/en_US/i/scr/pixel.gif" alt="" width="1" height="1" /></form></div>""",""),

("""<div class="¤"><a href="http://ode-math.com/" rel="nofollow">Differential Equations, Mechanics, and Computation</a></div>""",""),

("""<section class="buy-book">
Want to master JavaScript in a week? Buy <a href="buy_xah_js_tutorial.html">Xah JavaScript Tutorial</a>.
<div class="pp_xah_js_tutorial">
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick" />
<input type="hidden" name="hosted_button_id" value="J3BC865C77JUC" />
<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!" />
<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1" />
</form>
</div>
</section>""",""),


("""<section class="buy-book">
Want to master JavaScript in a week? Buy <a href="../buy_xah_js_tutorial.html">Xah JavaScript Tutorial</a>.
<div class="pp_xah_js_tutorial">
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick" />
<input type="hidden" name="hosted_button_id" value="J3BC865C77JUC" />
<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!" />
<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1" />
</form>
</div>
</section>""",""),

]



for x in find_replace_list:
    if len(x) != 2:
        sys.exit("Error: replacement pair has more than 2 elements. Probably missing a comma.")

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
        output_text = file_content.replace(a_pair[0], a_pair[1])
        file_content = output_text

    if num_replaced > 0:
        print("◆ ", num_replaced, " ", file_path.replace(os.sep, "/"))
        shutil.copy2(file_path, backup_fname)
        output_file = open(file_path, "w")
        output_file.write(output_text)
        output_file.close()
    else:
        if print_filename_when_no_change == True:
            print("no change:", file_path)

#────────── ────────── ────────── ────────── ──────────

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
                if (re.search(r"\.html$", fName, re.U)):
                    replace_string_in_file(dirPath + os.sep + fName)
                    # print ("level %d,  %s" % (curFileLevel, os.path.join(dirPath, fName)))

print("Done.")
