// find replace string pairs in a dir
// no regex
// version 2019-01-13
// website: http://xahlee.info/golang/goland_find_replace.html

package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"time"
)

const (
	// inDir is dir to start. must be full path
	inDir        = "c:/Users/xah/web/xahlee_org/diklo/zz/"
	fnameRegex   = `\.html$`
	writeToFile  = true
	doBackup     = false
	backupSuffix = "~~"
)

var dirsToSkip = []string{".git"}

// fileList if not empty, only these are processed. Each element is a full path
var fileList = []string{}

// frPairs is a slice of frPair struct.
var frPairs = []frPair{

	// emacs site
	frPair{
		findStr: `<!-- Global site tag (gtag.js) - Google Analytics -->`,
		replaceStr: ``,
	},

	frPair{
		findStr: `<script async src="https://www.googletagmanager.com/gtag/js?id=UA-10884311-3"></script>`,
		replaceStr: ``,
	},

	frPair{
		findStr: `<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-10884311-3');
</script>`,
		replaceStr: ``,
	},

	frPair{
		findStr: `<div class="ad_top_39054">
</div>`,
		replaceStr: ``,
	},

	frPair{
		findStr: `<div class="ads_bottom_dtpcz">
</div>`,
		replaceStr: ``,
	},

	frPair{
		findStr: `<div class="buyxahemacs97449">
<p>If you have a question, put $5 at <a class="sorc" target="_blank" href="https://www.patreon.com/xahlee" data-accessed="2017-08-01">patreon</a> and message me.
<br />
Or <a href="http://ergoemacs.org/emacs/buy_xah_emacs_tutorial.html">Buy Xah Emacs Tutorial</a>
<br />
Or buy
<a href="http://xahlee.info/js/js.html">JavaScript in Depth</a>
</p>
</div>`,
		replaceStr: ``,
	},

	// xahlee.info

	frPair{
		findStr: `<!-- Global site tag (gtag.js) - Google Analytics -->`,
		replaceStr: ``,
	},

	frPair{
		findStr: `<script async src="https://www.googletagmanager.com/gtag/js?id=UA-10884311-1"></script>`,
		replaceStr: ``,
	},


	frPair{
		findStr: `<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-10884311-1');
</script>`,
		replaceStr: ``,
	},


	frPair{
		findStr: `<div class="payme88711">
<ul>
<li><a class="sorc" target="_blank" href="https://www.patreon.com/xahlee" data-accessed="2019-01-24">patreon me $5</a></li>
<li><a class="sorc" target="_blank" href="https://www.amazon.com/gp/product/B004LLIKVU" data-accessed="2020-08-11">amazon egift card</a> to xah@xahlee.org , $20 is nice.</li>
<li><a class="sorc" target="_blank" href="https://www.paypal.com/" data-accessed="2019-01-24">paypal</a> to xah@xahlee.org , $20 is nice.</li>
<li>bitcoin me <small>19dfoa3Q7oehm9MwCULQzBG8vqfCaeMazH</small></li>
</ul>
</div>`,
		replaceStr: ``,
	},


	frPair{
		findStr: `<div class="ads_bottom_dtpcz">
<div>
<a href="buy_xah_js_tutorial.html" style="border: solid thin gray;border-radius:1rem;padding:8px;">
<span style="font-family:'Times New Roman', serif;font-size:60px">∑</span>
<span style="font-family:Arial;font-size:40px;font-weight:bold">JS</span>
<span style="font-family:'Arial';font-size:20px; font-weight:bold"><sup>in Depth</sup></span><br />
<span style="font-family:'Times New Roman', serif;font-size:20px;">XAH</span>
 BUY NOW</a>
</div>
</div>`,
		replaceStr: ``,
	},

}

// ------------------------------------------------------------

type frPair struct {
	findStr    string // find string
	replaceStr string // replace string
}

// stringMatchAny return true if x equals any of y
func stringMatchAny(x string, y []string) bool {
	for _, v := range y {
		if x == v {
			return true
		}
	}
	return false
}

func printSliceStr(sliceX []string) error {
	for k, v := range sliceX {
		fmt.Printf("%v %v\n", k, v)
	}
	return nil
}

func doFile(path string) error {
	contentBytes, er := ioutil.ReadFile(path)
	if er != nil {
		fmt.Printf("processing %v\n", path)
		panic(er)
	}
	var content = string(contentBytes)
	var changed = false
	for _, pair := range frPairs {
		var found = strings.Index(content, pair.findStr)
		if found != -1 {
			content = strings.Replace(content, pair.findStr, pair.replaceStr, -1)
			changed = true
		}
	}
	if changed {
		fmt.Printf("changed: %v\n", path)

		if writeToFile {
			if doBackup {
				err := os.Rename(path, path+backupSuffix)
				if err != nil {
					panic(err)
				}
			}
			err2 := ioutil.WriteFile(path, []byte(content), 0644)
			if err2 != nil {
				panic("write file problem")
			}
		}
	}
	return nil
}

var pWalker = func(pathX string, infoX os.FileInfo, errX error) error {
	if errX != nil {
		fmt.Printf("error 「%v」 at a path 「%q」\n", errX, pathX)
		return errX
	}
	if infoX.IsDir() {
		if stringMatchAny(filepath.Base(pathX), dirsToSkip) {
			return filepath.SkipDir
		}
	} else {
		var x, err = regexp.MatchString(fnameRegex, filepath.Base(pathX))
		if err != nil {
			panic("stupid MatchString error 59767")
		}
		if x {
			doFile(pathX)
		}
	}
	return nil
}

func main() {
	scriptPath, errPath := os.Executable()
	if errPath != nil {
		panic(errPath)
	}

	fmt.Println("-*- coding: utf-8; mode: xah-find-output -*-")
	fmt.Printf("%v\n", time.Now())
	fmt.Printf("Script: %v\n", filepath.Base(scriptPath))
	fmt.Printf("In dir: %v\n", inDir)
	fmt.Printf("File regex filter: %v\n", fnameRegex)
	fmt.Printf("Write to file: %v\n", writeToFile)
	fmt.Printf("Do backup: %v\n", doBackup)
	fmt.Printf("fileList:\n")
	printSliceStr(fileList)
	fmt.Printf("Find replace pairs: 「%v」\n", frPairs)
	fmt.Println()

	if len(fileList) >= 1 {
		for _, v := range fileList {
			doFile(v)
		}
	} else {
		err := filepath.Walk(inDir, pWalker)
		if err != nil {
			fmt.Printf("error walking the path %q: %v\n", inDir, err)
		}
	}

	fmt.Println()

	if !writeToFile {
		fmt.Printf("Note: writeToFile is %v\n", writeToFile)
	}

	fmt.Printf("%v\n", "Done.")
}
