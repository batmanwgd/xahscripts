# -*- coding: utf-8 -*-

from BeautifulSoup import BeautifulSoup
import urllib2

html_page = urllib2.urlopen("http://wordyenglish.com/lit/blog.html")
soup = BeautifulSoup(html_page)
for link in soup.findAll('a'):
    print link.get('href')
