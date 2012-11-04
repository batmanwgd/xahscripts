# fix all permissions

find . -type f -print0 | xargs -0 -l -i chmod 644 '{}'
find . -type d -print0 | xargs -0 -l -i chmod 755 '{}'


find . -name "*.html" -print0 | xargs -0 -l -i chmod 644 '{}'
find . -name "*.txt" -print0 | xargs -0 -l -i chmod 644 '{}'

find . -name "*.hqx" -o -name "*.sit" -o -name "*.gz" -print0 | xargs -0 -l -i chmod 644 '{}'
#find . -name "*.PPC" -print0 | xargs -0 -l -i chmod 644 '{}'

find . \( -name "*.jpg" -o -name "*.gif" -o -name "*.png" -o -name "*.mov" \) -print0 | xargs -0 -l -i chmod 644 '{}'

find . \( -name "*.nb" -o -name "*.m" -o -name "*.gsp" -o -name "*.fig" \) -print0 | xargs -0 -l -i chmod 644 '{}'

find . -type d -print0 | xargs -0 -l -i chmod 755 '{}'