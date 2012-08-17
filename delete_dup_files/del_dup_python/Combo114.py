# -*- coding: utf-8 -*-
# Python

# Xah Lee, XahLee.org, 200503
# http://xahlee.org/perl-python/delete_dup_files.html

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


def merge(pairings): # pairings is a list of couples. e.g. [(9,2),(7,6),...]

    # interm is a list of groups. Each group is a list that hold
    # equivalent numbers. interm stands for interim result. Each group
    # is a dictionary. Keys are numbers, values are all dummy
    # 'x'. Dictionary is used for ease of dealing with duplicates or
    # checking existence.
    interm=[];

    # move first pair of pairings into interm as the first group
    interm.append({pairings[0][0]:'x', pairings[0][1]:'x'}) ; del pairings[0]

    # go thru pairings. For each pair, check if it is in any group in
    # interm. If any part of pair is in a group, then add the other
    # part into that group. If no part of the pair is in any group,
    # then add this pair into interm as a new group.
    for aPair in pairings:
        for aGroup in interm:
            if (aGroup.has_key(aPair[0])): aGroup[aPair[1]]='x'; break
            if (aGroup.has_key(aPair[1])): aGroup[aPair[0]]='x'; break
        else: interm.append( {aPair[0]:'x'} ); interm[-1][aPair[1]]='x'

    # now make another pass of the groups in interm, because some pair
    # that may connect two groups (i.e. with one element in one group,
    # and second element in another group), yet the pair is simply
    # consumed by a group.
    # This pass will check if there are any element in any other
    # group, if so, such two groups will be unioned. In this pass, we
    # move things from interm into fin. fin==final.
    fin=[]; fin.append(interm.pop(0))
    goto=False
    for group in interm:
        for newcoup in fin:
            for k in group.keys():
                if newcoup.has_key(k):
                    newcoup.update(group);
                    goto=True
                    break
            if (goto):
                goto=False
                break
        else:
            fin.append(group)

    # now turn the dictionaries into lists for return value
    result=[];
    for group in fin: result.append(group.keys())
    return result
