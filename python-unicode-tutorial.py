# -*- coding: utf-8 -*-
# python 2

# 2012-06-29
# http://nedbatchelder.com/text/unipain.html
# 2012, Ned Batchelder

my_string = "hi"
print type(my_string)
# <type 'str'>
 
my_unicode = u"Hi \u2119\u01b4\u2602\u210c\xf8\u1f24"
print type(my_unicode)
# <type 'unicode'>

my_unicode = u"Hi •"
print type(my_unicode)
# <type 'unicode'>


# To convert between bytes and unicode, each has a method. Unicode
# strings have a .encode() method that produces bytes, and byte
# strings have a .decode() method that produces unicode. Each takes an
# argument, which is the name of the encoding to use for the
# operation.



 my_unicode = u"Hi \u2119\u01b4\u2602\u210c\xf8\u1f24"
len(my_unicode)
# 9
 
my_utf8 = my_unicode.encode('utf-8')
len(my_utf8)
# 19
my_utf8
# 'Hi \xe2\x84\x99\xc6\xb4\xe2\x98\x82\xe2\x84\x8c\xc3\xb8\xe1\xbc\xa4'
 
my_utf8.decode('utf-8')
# u'Hi \u2119\u01b4\u2602\u210c\xf8\u1f24'
