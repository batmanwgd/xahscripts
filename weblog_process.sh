# 2008-04-16 , 2010-08-09
# Xah Lee ∑ http://xahlee.org/

inputFile="xx";

# filter out bad accesses
cat $inputFile | grep '" 200 ' | grep '] "GET ' | grep -v -E "scoutjet\.com|yahoo.com/help/us/ysearch/slurp|google\.com/bot|msn.com/msnbot\.htm|dotnetdotcom\.org|yandex\.com/bots" > x-log_200_GET.txt

cat $inputFile | cut -d '"' -f 6 | sort | uniq -c | sort -n -r > x-agents.txt

cat x-agents.txt | grep -i -E "bot|crawler|spider|http" > x-bots.txt

#----------
# get stumble referrals
cat x-log_200_GET.txt | grep '\.html HTTP' | awk '$12 ~ /stumbleupon\.com/ {print $12 , $7}' | sort | sed s/refer.php/url.php/ | uniq -c | sort -n -r > x-referral_stumble.sh

# get youporn referrals
cat x-log_200_GET.txt | grep '\.html HTTP' | awk '$12 ~ /youporn\.com/ {print $12 , $7}' | sort | uniq -c | sort -n -r > x-referral_youporn.sh

# get Wikipedia referrals
cat x-log_200_GET.txt | awk '$12 ~ /wikipedia.org/ {print $12}' | sort | uniq -c | sort -n -r > x-referral_Wikipedia.sh

# get blog sites referrals
cat x-log_200_GET.txt | grep '\.html HTTP' | awk '$12 ~ /delicious\.com|livejournal\.com|multiply\.com|blogspot\.com|reddit\.com|twitter\.com|swik\.net|google\.com\/reader\/view/ {print $12 , $7}' | sort | sed s/refer.php/url.php/ | uniq -c | sort -n -r > x-referral_blog.sh

# get all referrals from non-search sites
cat x-log_200_GET.txt | grep '\.html HTTP' | awk '$12 !~ /xahlee.org|-|\?|stumbleupon\.com|youporn\.com|wikipedia.org|delicious\.com|livejournal\.com|multiply\.com|blogspot\.com|reddit\.com|twitter\.com|swik\.net|http:\/\/www\.google/ {print $12 , $7}' | sort | uniq -c | sort -n -r > x-referral_nonsearch.sh

# get all referrals from search sites
cat x-log_200_GET.txt | grep '\.html HTTP' | awk '$12 ~ /\?/ {print $12 , $7}' | grep -v stumbleupon\.com | sort | uniq -c | sort -n -r | head -n 500 > x-referral_search.sh

#----------

# most popular page
cat x-log_200_GET.txt | grep '\.html HTTP' | awk '{ print $7 }' | sort | uniq -c | sort -n -r > x-pop-site_all.sh

# popularity by directory

cat x-pop-site_all.sh | grep "/MathGraphicsGallery_dir/" > x-pop-site_math_gallery.sh
cat x-pop-site_all.sh | grep "/Periodic_dosage_dir/bangu/" > x-pop-site_bangu.sh
cat x-pop-site_all.sh | grep "/Periodic_dosage_dir/lacru/" > x-pop-site_lacru.sh
cat x-pop-site_all.sh | grep "/Periodic_dosage_dir/lanci/" > x-pop-site_lanci.sh
cat x-pop-site_all.sh | grep "/Periodic_dosage_dir/las_vegas/" > x-pop-site_vegas.sh
cat x-pop-site_all.sh | grep "/Periodic_dosage_dir/sanga_pemci/" > x-pop-site_sanga_pemci.sh
cat x-pop-site_all.sh | grep "/Periodic_dosage_dir/t1/" > x-pop-site_t1.sh
cat x-pop-site_all.sh | grep "/Periodic_dosage_dir/t2/" > x-pop-site_t2.sh
cat x-pop-site_all.sh | grep "/SpecialPlaneCurves_dir/" > x-pop-site_curve.sh
cat x-pop-site_all.sh | grep "/UnixResource_dir/" > x-pop-site_UnixResource.sh
cat x-pop-site_all.sh | grep "/Vocabulary_dir/" > x-pop-site_vocab.sh
cat x-pop-site_all.sh | grep "/Wallpaper_dir/" > x-pop-site_wallpaper-group.sh
cat x-pop-site_all.sh | grep "/3d/" > x-pop-site_3d.sh
cat x-pop-site_all.sh | grep "/dinju/" > x-pop-site_dinju.sh
cat x-pop-site_all.sh | grep "/emacs/" > x-pop-site_emacs.sh
cat x-pop-site_all.sh | grep "/elisp/" > x-pop-site_elisp.sh
cat x-pop-site_all.sh | grep "/java-a-day/" > x-pop-site_java.sh
cat x-pop-site_all.sh | grep "/js/" > x-pop-site_javascript.sh
cat x-pop-site_all.sh | grep "/p/" > x-pop-site_literature.sh
cat x-pop-site_all.sh | grep "/perl-python/" > x-pop-site_perl-python.sh
cat x-pop-site_all.sh | grep "/sl/" > x-pop-site_sl.sh
cat x-pop-site_all.sh | grep "/surface/" > x-pop-site_surface.sh
cat x-pop-site_all.sh | grep "/vofli_bolci/" > x-pop-site_juggling.sh
cat x-pop-site_all.sh | grep "/xamsi_calku/" > x-pop-site_xamsi_calku.sh


# echo "" > x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_UnixResource.sh) UnixResource" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_3d.sh) 3d" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_curve.sh) curve" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_bangu.sh) bangu" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_dinju.sh) dinju" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_emacs.sh) emacs" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_elisp.sh) elisp" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_java.sh) java" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_javascript.sh) js" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_juggling.sh) juggling" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_lacru.sh) lacru" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_lanci.sh) lanci" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_literature.sh) literature" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_math_gallery.sh) math_gallery" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_perl-python.sh) perl-python" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_sanga_pemci.sh) sanga_pemci" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_sl.sh) sl" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_surface.sh) surface" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_t1.sh) dosage_t1" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_t2.sh) dosage_t2" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_vegas.sh) las vegas" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_vocab.sh) vocab" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_wallpaper-group.sh) wallpaper-group" >> x-pop-site_compare.sh
# echo "$(awk '{sum += $1} END {print sum}' x-pop-site_xamsi_calku.sh) xamsi_calku" >> x-pop-site_compare.sh

# cat x-pop-site_compare.sh | sort -n -r > x-pop-site_compare.sh

#----------

# count JavaView access
cat x-log_200_GET.txt | grep -E '_jv_.+ HTTP' | awk '{print $7}' | sort | uniq -c | sort -n -r > x-pop-type_jv.sh

# count Geogebra access
cat x-log_200_GET.txt | grep '\.ggb HTTP' | awk '{print $7}' | sort | uniq -c | sort -n -r > x-pop-type_ggb.sh

# count elisp files access
cat x-log_200_GET.txt | grep '\.el HTTP' | awk '{print $7}' | sort | uniq -c | sort -n -r > x-pop-type_el.sh

# count fig files access
cat x-log_200_GET.txt | grep '\.fig HTTP' | awk '{print $7}' | sort | uniq -c | sort -n -r > x-pop-type_fig.sh

# count gsp files access
cat x-log_200_GET.txt | grep '\.gsp HTTP' | awk '{print $7}' | sort | uniq -c | sort -n -r > x-pop-type_gsp.sh

#----------

# all kml downloads
cat x-log_200_GET.txt | awk '$0 ~ /\.kml HTTP/ {print $7}' | sort | uniq -c | sort -n -r > x-pop-type_kml.sh

# all jar downloads
cat x-log_200_GET.txt | awk '$0 ~ /\.jar HTTP/ {print $7}' | sort | uniq -c | sort -n -r > x-pop-type_jar.sh

# all gz downloads
cat x-log_200_GET.txt | awk '$0 ~ /\.gz HTTP/ {print $7}' | sort | uniq -c | sort -n -r > x-pop-type_gz_all.sh

#----------
# all zip downloads
cat x-log_200_GET.txt | awk '$0 ~ /\.zip HTTP/ {print $7}' | sort | uniq -c | sort -n -r > x-pop-type_zip_all.sh

#----------

# leechers
cat x-log_200_GET.txt | grep -v -i '\.html HTTP' | awk '$12 !~ /xahlee\.org|xahporn\.org|xahlee\.info|xahlee\.blogspot\.com|-/ {print $12, $7}' | sort | uniq -c | sort -n -r > x-leechers.sh
