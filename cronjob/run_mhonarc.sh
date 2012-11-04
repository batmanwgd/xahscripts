#!/usr/local/bin/bash

/usr/local/bin/sudo /usr/local/bin/mhonarc \
/var/mail/dev_nile \
 -title "dev nile mailing list archive (sort by descending date)" \
-ttitle "dev nile mailing list Archive by thread" \
-sort -reverse \
-outdir '/www/intranet/htdocs/dev_nile_archive' \
-rcfile '/home2/xah/cron_dir/mhonarc_resource.txt' \
> out.txt

