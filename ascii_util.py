# -*- coding: utf-8 -*-
# python

# utility to show the difference of JavaScript's encodeURI and encodeURIComponent functions

# 2013-12-09

digits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}

letters_upper = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}

letters_lower = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}

printable_ascii = digits.union(letters_upper, letters_lower,
{'!', '"', '#', '$', '%', '&', "'", '(', ')', '*', '+', ',', '-', '.', '/' , ':', ';', '<', '=', '>', '?', '@', '[', '\\', ']', '^', '_', '`', '{', '|', '}', '~' })

encodeURIComponent_not_encoded_ascii_chars = digits.union(letters_upper, letters_lower, {"""-""", """_""", """.""", """!""", """~""", """*""", """'""", """(""", """)"""})

encodeURIComponent_encoded_ascii_chars = printable_ascii - encodeURIComponent_not_encoded_ascii_chars

encodeURI_not_encoded_ascii_chars  =  digits.union(letters_upper, letters_lower,
{"""-""", """_""", """.""", """!""", """~""", """*""", """'""", """(""", """)""", """;""", """,""", """/""", """?""", """:""", """@""", """&""", """=""", """+""", """$""", """#"""})

encodeURI_encoded_ascii_chars = printable_ascii - encodeURI_not_encoded_ascii_chars

print encodeURI_encoded_ascii_chars

