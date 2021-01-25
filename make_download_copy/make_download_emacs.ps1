get-date

$outDir='c:/Users/xah/web/xahlee_org/diklo/zz/'
$emacsDir='c:/Users/xah/web/ergoemacs_org/'
$goRemoveAds='c:/Users/xah/git/xahscripts/make_download_copy/find_replace_ads.go'

mkdir $outDir
Copy-Item -Path ($emacsDir+'*') -Destination $outDir -Recurse -Exclude '.git'

go run $goRemoveAds

Get-ChildItem ($outDir+'*') -Recurse -Include *~ | remove-item
Get-ChildItem ($outDir+'*') -Recurse -Include '#*#' | remove-item
Get-ChildItem ($outDir+'*') -Recurse -Include '.DS_Store' | remove-item
Get-ChildItem ($outDir+'*') -Recurse -Include '.htaccess' | remove-item
Get-ChildItem ($outDir+'*') -Recurse -Include 'xx*' | remove-item

rm ($outDir+'ads.txt')

get-date

