# -*- coding: utf-8 -*-
# Python

# Xah Lee, XahLee.org, 200503
# http://xahlee.org/perl-python/delete_dup_files.html

def parti(li,sameQ):
    tray=[1]
    result=[]
    for i in range(1, len(li) ):
        if sameQ(li[i-1],li[i]):
            tray.append(i+1)
        else:
            result.append(tray)
            tray=[i+1]
    result.append(tray)
    return result



def genpair (partiSet):
    result={}
    for head in range(len(partiSet)-1):
        for tail in range(head+1,len(partiSet)):
            for ii in partiSet[head]:
                for jj in partiSet[tail]:
                    result["%d,%d"%(ii,jj)]=(ii,jj)
    return result
