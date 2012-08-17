
import Combo114

#aa = {1:(5,6),3:(7,6)}
#
#for k in aa.itervalues():
#    a2=aa.copy()
#    m=a2.popitem()
#    print m
#print aa
#print a2


a= Combo114.combo(120)
if ( Combo114.reduce( a, [2,3]) ==  Combo114.reduce2( a, [2,3]) ):
    print 'yea'
else:
    print 'na'
