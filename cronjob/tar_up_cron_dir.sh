#!/usr/local/bin/bash

cd /home2/xah;
tar cf cron_dir.tar cron_dir && \
/usr/local/bin/gzip -f cron_dir.tar && \
mv -f cron_dir.tar.gz \
/home2/xah/temp_garbage_dir
