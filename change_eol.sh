# replace mac 13 eol to unix 10 eol.
find . -name "*.html" | xargs perl -pi'*~' -e 's@\x0D@\x0A@g'
