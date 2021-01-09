# 2020-11-21

date

dateStr=`date "+%Y-%m-%d"`
outRoot="/Users/xah"

archive_dir() {
    dirName="${1}"
    baseName=`basename ${dirName}`
    zipName="${baseName}_${dateStr}.zip"
    outDir="${outRoot}/${zipName}"
    gitDotDir="${dirName}/.git"
    echo $outDir
    # if [ -f "$outDir" ]; then
        # rm $outDir
    # fi

    git --git-dir=${gitDotDir} archive -o $outDir HEAD

}

archive_dir "/Users/xah/web/ergoemacs_org"
archive_dir "/Users/xah/web/wordyenglish_com"
archive_dir "/Users/xah/web/xaharts_org"
archive_dir "/Users/xah/web/xahlee_info"
archive_dir "/Users/xah/web/xahlee_org"
archive_dir "/Users/xah/web/xahmusic_org"
archive_dir "/Users/xah/web/xahsl_org"

archive_dir "/Users/xah/Documents"
archive_dir "/Users/xah/Downloads"
archive_dir "/Users/xah/Pictures"
archive_dir "/Users/xah/Videos"

date

