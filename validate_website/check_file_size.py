# -*- coding: utf-8 -*-
# Python

# 2005-10-05
# given a dir, report all html file's size. (counting inline images)
# XahLee.org

import re, os.path, sys

inpath= "C:/Users/xah/web/xahlee_org/funny"
sizelimit= 800 * 1000;

while inpath[-1] == '/': inpath = inpath[0:-1] # get rid of trailing slash

if (not os.path.exists(inpath)):
    print "dir " + inpath + " doesn't exist!"
    sys.exit(1)

##################################################
# subroutines

def getInlineImg(file_full_path):
    '''getInlineImg($file_full_path) returns a array that is a list of inline images. For example, it may return ['xx.jpg','../image.png']'''    
    FF = open(file_full_path,'rb')
    txt_segs = re.split( r'img src', unicode(FF.read(),'utf-8'))
    txt_segs.pop(0)
    FF.close()
    linx=[]
    for linkBlock in txt_segs:
        matchResult = re.search(r'\s*=\s*\"([^\"]+)\"', linkBlock)
        if matchResult: linx.append( matchResult.group(1) ) 
    return linx


def linkFullPath(dir,locallink):
    '''linkFullPath(dir, locallink) returns a string that is the full path to the local link. For example, linkFullPath('/Users/t/public_html/a/b', '../image/t.png') returns 'Users/t/public_html/a/image/t.png'. The returned result will not contain double slash or '../' string.'''
    result = dir + '/' + locallink
    result = re.sub(r'//+', r'/', result)
    while re.search(r'/[^\/]+\/\.\.', result): result = re.sub(r'/[^\/]+\/\.\.', '', result)
    return result

def listInlineImg(htmlfile):
    '''listInlineImg($html_file_full_path) returns a array where each element is a full path to inline images in the html.'''
    dir=os.path.dirname(htmlfile)
    imgPaths = getInlineImg(htmlfile)
    result = []
    for aPath in imgPaths:
        result.append(linkFullPath( dir, aPath))
    return result

##################################################
# main

fileSizeList=[]
def checkLink(dummy, dirPath, fileList):
    for fileName in fileList:
        if '.html' == os.path.splitext(fileName)[1] and os.path.isfile(dirPath+'/'+fileName):
            totalSize = os.path.getsize(dirPath+'/'+fileName)
            imagePathList = listInlineImg(dirPath+'/'+fileName)
            for imgPath in imagePathList: totalSize += os.path.getsize(imgPath)
            fileSizeList.append([totalSize, dirPath+'/'+fileName])

os.path.walk(inpath, checkLink, 'dummy')

fileSizeList.sort(key=lambda x:x[0],reverse=True)

for it in fileSizeList: print it
