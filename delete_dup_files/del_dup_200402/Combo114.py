# -*- coding: utf-8 -*-
# Python

def combo(n):
    '''returns all possible (unordered) pairs out of n numbers 1 to n.

    Returns a dictionary. The keys are of the form "n,m", 
    and their values are tuples. e.g. combo(4) returns
    {'3,4': (3, 4), '1,4': (1, 4), '1,2': (1, 2),
    '1,3': (1, 3), '2,4': (2, 4), '2,3': (2, 3)}'''
    return dict([('%d,%d'%(i,j),(i,j)) for j in range(1,n+1) for i in range(1,j)])



def reduce(pairings, pair):
    ps=pairings.copy(); j=pair;
    ps.pop("%d,%d"%(j[0],j[1]),0)
    for k in pairings.itervalues():
	if (k[0]==j[0]):
            if (j[1] < k[1]):
                ps.pop("%d,%d"%(j[1],k[1]),0)
            else:
                ps.pop("%d,%d"%(k[1],j[1]),0)
        if (k[1]==j[0]):
            if (k[0] < j[1]):
                ps.pop("%d,%d"%(k[0],j[1]),0)
            else:
                ps.pop("%d,%d"%(j[1],k[0]),0)
    return ps

def reduce2( pairings, pair ):
    result={}
    for i,j in pairings.itervalues():
        if i in pair: i=pair[0]
        if j in pair: j=pair[0]
        if i>j: (i,j) = (j,i)
        if i!=j: result["%d,%d"%(i,j)] = (i,j)
    return result
