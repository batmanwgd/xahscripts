# XAH functions

def xah_combo (n):
    '''returns all possible (unordered) pairs out of n numbers 1 to n.

    Returns a dictionary. The keys are of the form "n,m", 
    and their values are tuples. e.g. combo(4) returns
    {'3,4': (3, 4), '1,4': (1, 4), '1,2': (1, 2),
    '1,3': (1, 3), '2,4': (2, 4), '2,3': (2, 3)}'''
    result={}
    for j in range(1,n):
        for i in range(1,n+1):
            m = ((i+j)-1) % n + 1
            if (i < m):
                result["%d,%d"%(i,m)]=(i,m)
    return result

def xah_reduce(pairings, pair):
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

def xah_merge(pairings): # pairings is a list of couples. e.g. [(9,2),(7,6),...]

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
     for group in interm:
         for newcoup in fin:
             for k in group.keys():
                 if newcoup.has_key(k):
                     for kk in group.keys(): newcoup[kk]='x';
                 break
             break
         fin.append(group)

     # now turn the dictionaries into lists for return value
     result=[];
     for group in fin: result.append(group.keys())
     return result

# GUGLER functions

def parti (list, equalFunc):  #uses previous exercises
    n = len(list)
    equals = []
    tests = xah_combo (n)
    while len(tests):
        (key, (a,b)) = tests.popitem()
        if equalFunc( list[a-1], list[b-1] ):
            equals.append( (a,b) )
            xah_reduce (tests, (a,b))
    equals += [(i,i) for i in range(1,n+1)]
    return xah_merge (equals)

def parti_custom (list, equalFunc):  #has no dependencies
    result = []
    for i in range(len(list)):
        for s in result:
            if equalFunc( list[i], list[s[0]] ):
                s.append(i)
                break
        else:
            result.append( [i] )
    return [[x+1 for x in L] for L in result]

if __name__ == "__main__":
    def eq (x,y): return x==y
    def runtest (list, test):
        print parti (list, test)
        print parti_custom (list, test)
    li=[4, 4, 1, 1, 2, 0, 0, 1, 3]
    runtest (li, eq)
    li=[3, 5, 2, 1, 2, 1, 5, 2, 3, 1, 3]
    runtest (li, eq)

# OUTPUT:
# 
# [[8, 3, 4], [1, 2], [6, 7], [5], [9]]
# [[1, 2], [3, 4, 8], [5], [6, 7], [9]]
# [[1, 11, 9], [10, 4, 6], [2, 7], [8, 3, 5]]
# [[1, 9, 11], [2, 7], [3, 5, 8], [4, 6, 10]]

