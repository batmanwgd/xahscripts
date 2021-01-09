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
    # 2020-11-25

('''<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-10884311-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-10884311-1');
</script>''',
''),

('''<script data-ad-client="ca-pub-5125343095650532" async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>''',
''),

('''<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- xlinfo_top_autosize_20171107 -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="2984018199"
     data-ad-format="auto"
     data-full-width-responsive="true"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>''',
''),


('''<div>
<a href="buy_xah_js_tutorial.html">
<span style="color:red">
<span style="font-family:'Times New Roman', serif;font-size:60px">∑</span>
<span style="font-family:Arial;font-size:40px;font-weight:bold">JS</span>
<span style="font-family:'Arial';font-size:20px; font-weight:bold"><sup>in Depth</sup></span><br />
<span style="font-family:'Times New Roman', serif;font-size:20px;">XAH</span>
</span>
Buy Xah JavaScript Tutorial</a>
</div>''',
''),


##################################################
    # emacs site, 

('''<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-10884311-3"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-10884311-3');
</script>
''',
''),

(
'''<div class="buyxahemacs97449">
<p>If you have a question, put $5 at <a class="sorc" target="_blank" href="https://www.patreon.com/xahlee" data-accessed="2017-08-01">patreon</a> and message me.
<br />
Or <a href="http://ergoemacs.org/emacs/buy_xah_emacs_tutorial.html">Buy Xah Emacs Tutorial</a>
<br />
Or buy
<a href="http://xahlee.info/js/js.html">JavaScript in Depth</a>
</p>
</div>''',
''
),

    # #####################################

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

    # print ("reading:", file_path)
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

print("Done removing ads.")
