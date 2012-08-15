# 2009-06-26
# check on not allowed file name chars on NTFS
# run this in OS X or linux before copying to Windows

# http://xahlee.info/mswin/allowed_chars_in_file_names.html

find . -name "*\/*"
find . -name "*\:*"
find . -name "*\**"
find . -name "*\?*"
find . -name "*\"*"
find . -name "*\<*"
find . -name "*\>*"
find . -name "*\|*"
find . -name "*\=*"
