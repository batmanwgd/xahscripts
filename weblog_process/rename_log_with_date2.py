# -*- coding: utf-8 -*-
# Python

import re,subprocess,os,time

# 2006-07-20
# go to the dir mydir
# get a list of file names of the form access.log.*
# for each file
# unzip it (make sure it doesn't override existing file)
# find the date from the first line and last line
# rename the file such as 0605-0612.log.gz

# this version requires the command line utility gzip.

mydir= "c:/Users/xah/Documents/web log/tcana_ciste_vreji/2009/x-weekly"
mydir= "c:/Users/h3/SkyDrive/weblog/tcana_ciste_vreji/2009"
mydir= "/media/sf_h3/SkyDrive/weblog/tcana_ciste_vreji/2009/"


# mydir= os.getcwd()

mon={
'Jan':'01',
'Feb':'02',
'Mar':'03',
'Apr':'04',
'May':'05',
'Jun':'06',
'Jul':'07',
'Aug':'08',
'Sep':'09',
'Oct':'10',
'Nov':'11',
'Dec':'12',
}

def getdate (li):
    li = li.split(' ')[3][1:12];
    datelist = li.split('/');
    dd=datelist[0]
    mmm=datelist[1]
    yyyy=datelist[2]
    return str(yyyy) + str(mon[mmm]) + str(dd)


for ff in os.listdir(mydir):
    if re.search(r'access.log.+',ff):
        corename=ff

#        corename=ff[0:-3] # name without the .gzip postfix
#        subprocess.Popen([r"/sw/bin/gzip","-d",mydir +'/'+ff]).wait()

        lfirst=subprocess.Popen([r"/usr/bin/head","-n 1",mydir +'/'+corename], stdout=subprocess.PIPE).communicate()[0]
        llast=subprocess.Popen([r"/usr/bin/tail","-n 1",mydir +'/'+corename], stdout=subprocess.PIPE).communicate()[0]

        start_date = getdate(lfirst)
        end_date = getdate(llast)
        newname = start_date + '-' + end_date + '.txt' #newname = new filename

        print ff, corename, newname
        os.rename(mydir +'/'+corename, mydir +'/'+newname); time.sleep(1)
#        subprocess.Popen([r"/sw/bin/gzip",mydir +'/'+newname]).wait()

print 'Program finished.'
