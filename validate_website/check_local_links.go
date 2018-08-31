// given a dir, check all local links and inline image links in the html files. Print a report.
// 2018-08-30

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
	inDir      = "/Users/xah/web/wordyenglish_com/"
	fnameRegex = `\.html$`
)

var dirsToSkip = []string{
	".git",
	"emacs_manual",
	"godoc",
	"REC-SVG11-20110816",
	"clojure-doc-1.8",
	"css_2.1_spec",
	"css_transitions",
	"javascript_ecma-262_5.1_2011",
	"javascript_ecma-262_6_2015",
	"javascript_es2016",
	"javascript_es6",
	"jquery_doc",
	"node_api",
	"ocaml_doc",
	"python_doc_2.7.6",
	"python_doc_3.3.3",
	"w3c_ui_events",
}

// ------------------------------------------------------------

// pass return false if x equals any of y
func pass(x string, y []string) bool {
	for _, v := range y {
		if x == v {
			return false
		}
	}
	return true
}

func fexists(fpath string) bool {
	if _, err := os.Stat(fpath); os.IsNotExist(err) {
		return false
	}
	return true
}

// removeFrac removes fractional part of url. eg remove #...
func removeFrac(url string) string {
	// fmt.Printf("now: %v\n", url)
	var x = strings.LastIndex(url, "#")
	if x != -1 {
		return url[0:x]
	}
	return url
}

// getLinks return all links from a html file
// return value looks like this
// [[ `href="cat.html"` `cat.html`] ...]
func getLinks(ss string) [][]string {
	var re = regexp.MustCompile(`<[-_=a-z0-9" ]+(?:href|src)+="([^"]+)"`)
	var lnks = re.FindAllStringSubmatch(ss, -1)
	return lnks
}

func doFile(path string) error {
	contentBytes, er := ioutil.ReadFile(path)
	if er != nil {
		panic(er)
	}
	var lnks = getLinks(string(contentBytes))
	for _, v := range lnks {
		var linkVal = v[1]
		var noWant, errM = regexp.MatchString(`^//|^http:|^https:|^mailto:|^irc:|^ftp:|^javascript:`, linkVal)
		if errM != nil {
			panic(errM)
		}
		if !noWant {
			var noFrag = removeFrac(linkVal)
			var linkedPath = filepath.Dir(path) + "/" + noFrag
			linkedPath = filepath.Clean(linkedPath)
			if !fexists(linkedPath) {
				fmt.Printf("%#v %#v\n", path, noFrag)
			}
		}
	}
	return nil
}

func main() {
	scriptName, errPath := os.Executable()
	if errPath != nil {
		panic(errPath)
	}

	fmt.Printf("%v\n", time.Now())
	fmt.Printf("Script: %v\n", filepath.Base(scriptName))
	fmt.Printf("In dir: %v\n", inDir)
	fmt.Printf("File regex filter: %v\n", fnameRegex)
	fmt.Println()

	var pWalker = func(pathX string, infoX os.FileInfo, errX error) error {
		if errX != nil {
			fmt.Printf("error 「%v」 at a path 「%q」\n", errX, pathX)
			return errX
		}
		if infoX.IsDir() {
			if !pass(filepath.Base(pathX), dirsToSkip) {
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

	err := filepath.Walk(inDir, pWalker)
	if err != nil {
		fmt.Printf("error walking the path %q: %v\n", inDir, err)
	}


	fmt.Printf("\n%v\n", "Done. bad links are printed above, if any.")
}
