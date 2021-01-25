get-date

$goRemoveAds='c:/Users/xah/git/xahscripts/make_download_copy/find_replace_ads.go'
$sourceDir="c:/Users/xah/web/xahlee_info/"
$outDir="c:/Users/xah/web/xahlee_org/diklo/zz/"

$dir1="js/"
$dir2="js_es2011/"
$dir3="js_es2015/"
$dir5="js_es2016/"
$dir6="js_es2018/"
$dir7="node_api/"

$file1='lbasic.css'
$file2='highlightlink24082.js'

mkdir ($outDir+$dir1)
mkdir ($outDir+$dir2)
mkdir ($outDir+$dir3)
mkdir ($outDir+$dir5)
mkdir ($outDir+$dir6)
mkdir ($outDir+$dir7)

Copy-Item -Path ($sourceDir+$dir1 +'*') -Destination ($outDir+$dir1) -Recurse
Copy-Item -Path ($sourceDir+$dir2 +'*') -Destination ($outDir+$dir2) -Recurse
Copy-Item -Path ($sourceDir+$dir3 +'*') -Destination ($outDir+$dir3) -Recurse
Copy-Item -Path ($sourceDir+$dir5 +'*') -Destination ($outDir+$dir5) -Recurse
Copy-Item -Path ($sourceDir+$dir6 +'*') -Destination ($outDir+$dir6) -Recurse
Copy-Item -Path ($sourceDir+$dir7 +'*') -Destination ($outDir+$dir7) -Recurse

Copy-Item ($sourceDir+$file1) $outDir
Copy-Item ($sourceDir+$file2) $outDir

go run $goRemoveAds

Get-ChildItem ($outDir+'*') -Recurse -Include *~ | remove-item
Get-ChildItem ($outDir+'*') -Recurse -Include '#*#' | remove-item
Get-ChildItem ($outDir+'*') -Recurse -Include '.DS_Store' | remove-item
Get-ChildItem ($outDir+'*') -Recurse -Include '.htaccess' | remove-item
Get-ChildItem ($outDir+'*') -Recurse -Include 'xx*' | remove-item

get-date
