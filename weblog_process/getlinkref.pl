# -*- coding: utf-8 -*-

# perl

# 2007-11-09. Status abandoned.

# take a apache logfile from cmd line, e.g. access.log.45.3
# prints a output of links and referer.

# readin the file one line at a time
# for each line, takes only the part file accessed and referral


# 72.27.88.250 - - [08/Nov/2007:23:59:58 -0500] "GET /PageTwo_dir/more.html HTTP/1.1" 200 10874 xahlee.org "http://xahlee.org/Periodic_dosage_dir/lacru/rama3.html" "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.9) Gecko/20071025 Firefox/2.0.0.9" "-"

@blogsites = qw(del.icio.us livejournal.com multiply.com blogspot.com reddit.com stumbleupon.com);

@searchEngines = qw(
alltheweb.com/search
altavista.com
search.aol.com
ask.com
dogpile.com
dogpile.co.uk
www.google
mail.google
images.google
mysearch.myway.com
netscape.com/search
search.114.vnet.cn
search.yahoo.com
search.cn.yahoo.com
search.yahoo.co.jp
search.comcast.net
search.earthlink.net
search.ke.voila.fr
search.live.com
search.msn
search.sympatico.msn.ca
search.myway.com
search.mywebsearch.com
search.ninemsn.com.au
search.opera.com
search.peoplepc.com
search.cnn.com
search.bbc.co.uk
search.alice.it
search.com
att.net
soso.com/q?
results?itag=
webcrawler.com
);


cat access.log.45.4 | grep -v -i -E -f search_engines.txt > logs-out.txt

grep 'html HTTP' logs-out.txt | awk '{print $12 , $7}' | grep -i -E -f blogsites.txt | sort | sed s/refer.php/url.php/ | uniq -c | sort -g


# 2007-11-02

# filter out search engines
cat access.log.* | grep -v -i -E -f search_engines.txt > logs-out.txt

# get referral from blog sites
grep 'html HTTP' logs-out.txt | awk '{print $12 , $7}' | grep -i -E -f blogsites.txt | sort | sed s/refer.php/url.php/ | uniq -c | sort -g

# get referral from Wikipedia
grep -i 'wikipedia' logs-out.txt | awk '{print $12}' | sort | uniq -c | sort -g

# get referral from others
grep 'html HTTP' logs-out.txt | awk '{print $12 , $7}' | grep -v -i -E "\"-\" |\"\"|xahlee.org|wikipedia.org" | grep -v -i -E -f blogsites.txt | sort | uniq -c | sort -g
