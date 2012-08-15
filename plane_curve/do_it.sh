# bash

# update steps:
# remove the one copy of curves folder under public_html
# copy over from Documents.
# delete mov fig gsp nb m etc files
# replace links to none-existant files.
# check local links.

rm -r /Users/t/SpecialPlaneCurves_dir
cp -r /Users/t/public_html/SpecialPlaneCurves_dir /Users/t/


# delete .mov etc files, and replace links
perl replace_links.pl 

# old stuff
perl delete_goodies.pl /Users/t/Documents/public_html/SpecialPlaneCurves_dir
perl replace_links.pl /Users/t/Documents/public_html/SpecialPlaneCurves_dir
perl check_local_link_dir.pl /Users/t/Documents/public_html/SpecialPlaneCurves_dir
