// 2018-08-10

// cd to xahlee info dir
// gen sitemap
// git add, commit
// delete emacs backup~

// time git clone --depth 1 file:///Users/xah/web/xahlee_info /Users/xah/xsiteout/xahlee_info

// time git checkout --depth 1 file:///Users/xah/web/wordyenglish_com /Users/xah/xsiteout/wordyenglish_com

// delete the .git dir
// rename the dir to xahcode

// # replace scripts and ads

// python3 /Users/xah/git/xahscripts/make_download_copy/find_replace_ads.py3 /Users/xah/xahcode

// # remove xx files and temp files etc
// python3 /Users/xah/git/xahscripts/make_download_copy/delete_temp_files.py3 /Users/xah/xahcode

package main

import (
	"fmt"
	// "io/ioutil"
	"os"
	"os/exec"
	// "path/filepath"
	// "regexp"
	// "strings"
	// "time"
)

// var fromDir = "/Users/xah/web/xahlee_info"
var fromDir = "/Users/xah/web/xaharts_org/"
var outDir = "/Users/xah/xxnew"

// fileExist. check if a file exist
func fileExist(path string) bool {
	_, err := os.Stat(path)
	if err == nil {
		return true
	}
	return false
}

func main() {

	if !fileExist(outDir) {
		err := os.Mkdir(outDir, 0770)
		if err != nil {
			panic(err)
		}
	}

	err := os.Chdir(outDir)
	if err != nil {
		panic(err)
	}

	var cmd = exec.Command("/usr/bin/git", "clone","--depth", "1",  "file://"+fromDir, "file://"+outDir)

	output, errGit := cmd.Output()
	if errGit != nil {
	    panic(errGit)
	}



	fmt.Printf("%v\n", string(output))

	// call this
// /Users/xah/git/xahscripts/make_download_copy/find_replace_ads.go

	fmt.Printf("%v\n", "Done.")


}
