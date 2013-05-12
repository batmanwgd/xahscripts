# -*- coding: utf-8 -*-
# replace classic Mac OS ASCII 13 line ending to unix ASCII 10 line ending.
find . -name "*.html" | xargs perl -pi'*~' -e 's@\x0D@\x0A@g'
