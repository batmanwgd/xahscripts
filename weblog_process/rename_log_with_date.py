# -*- coding: utf-8 -*-
# Python

import os,re,gzip

# 2006-07-20
# go to the current dir
# get a list of file names of the form access_log.*.gz
# for each file
# dearchive it it (make sure it doesn't override existing file)
# find the date from the first line and last line
# rename the file such as 0605-0612.log.gz

# this version uses Python's gzip library. i.e. it does not call system utility and it reads in the file after decompression. 

mydir= '/Users/t/na_vajni/tcana_ciste_vreji/2005ciste_vreji/xx'
mydir= "c:/Users/h3/SkyDrive/weblog/tcana_ciste_vreji/2009"

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
    if re.search(r'access_log\.\d\.gz',ff):
        print ff
        unzippedname=ff[0:-3]
        inF = gzip.GzipFile(ff, 'rb');
        s=inF.readlines()
        inF.close()

        start_date = getdate(s[0])
        end_date = getdate(s[-1])
        new_file_name= start_date + '-' + end_date + '.txt'

        outF = file(new_file_name, 'w');
        outF.write(''.join(s))
        outF.close()

        s[0:-1]=[]
