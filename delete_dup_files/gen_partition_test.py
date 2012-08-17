# Fri Mar  4 02:28:18 PST 2005

import Combo114

def parti(aList, equalFunc):
    a=0
    result = []
    for i in range(len(aList)):
         for s in result:
              a=a+1
              if equalFunc( aList[i], aList[s[0]] ):
                   s.append(i)
                   break
         else:
              result.append( [i] )
    print 'parti 1 run', a
    return [[x+1 for x in L] for L in result] # add 1 to all numbers



# incorrect result
def parti2 (list, equalFunc):
    n = len(list)
    equals = []
    tests = Combo114.combo (n)
    a=0
    while len(tests):
         (key, (a,b)) = tests.popitem()
         a=a+1
         if equalFunc( list[a-1], list[b-1] ):
              equals.append( (a,b) )
              Combo114.reduce (tests, (a,b))
    equals += [(i,i) for i in range(1,n+1)]
    print 'parti 2 run', a
    return Combo114.merge (equals)


import random
ml = [random.randint(1,3) for i in range(10)]
ml=[3, 5, 2, 1, 2, 1, 5, 2, 3, 1, 3]
ml.sort()
print ml
eqf = lambda x,y: x==y

import Genpair114
li=parti(ml,eqf)
li2=parti2(ml,eqf)
li3=Genpair114.parti(ml,eqf)
print li
print li2
print li3
