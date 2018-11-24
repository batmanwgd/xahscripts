// given a dir, check all local links and inline image links in the html files. Print a report.
// http://xahlee.info/golang/golang_validate_links.html
// Version 2018-08-30

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

// inDir is dir to start. must be full path. if it's a file, the parent dir is used

var inDir = "/Users/xah/web/xahlee_info/comp/blog.html"

const fnameRegex = `\.html$`

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
	"xx_arabian_nights_full_2017-05-13",
}

const posBracketL = '❪'
const posBracketR = '❫'

const fileBracketL = '〘'
const fileBracketR = '〙'

// ------------------------------------------------------------

// pass return false if x equals any of y
// version 2018-11-12
func pass(x string, y []string) bool {
	for _, v := range y {
		if x == v {
			return false
		}
	}
	return true
}

func isFileExist(fpath string) bool {
	if _, err := os.Stat(fpath); os.IsNotExist(err) {
		return false
	}
	return true
}

// removeFrac removes fractional part of url. eg remove #...
// version 2018-11-12
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
// version 2018-11-12
func getLinks(ss string) [][]string {
	// 2018-11-12 todo. in video tag, there's poster= attribute like this
	// <video src="i/cat.mp4" poster="cat.jpg"></video>
	// both src=val1 and poster=val2 should be in result. however, poster is not now, because we used regex to begin with the tag delimiter <. actually, we can make it work by href|src|poster but then we can't check the starting tag delimiter < to make sure it inside a html tag. If we do not regex regex match of < , then there'll be lots false links returned, due to when the html content is about html.
	// solution is to do a split of all <...>, then regex check each
	// var re = regexp.MustCompile(`<[-_=a-z0-9" ]+(?:href|src|poster)+="([^"]+)"`)
	// var re = regexp.MustCompile(` (?:href|src|poster)="([^"]+)"`)
	var re = regexp.MustCompile(`<[-_=a-z0-9" ]+(?:href|src)="([^"]+)"`)
	// var lnks = re.FindAllStringSubmatch(ss, -1)
	// return lnks

	var xlinks = re.FindAllStringSubmatchIndex(ss, -1)

	// var result [][]string
	// for _, v := range xlinks {
	// 	var x = []string{fmt.Sprintf("%d", (v[2])), ss[v[2]:v[3]], fmt.Sprintf("%d", (v[3]))}
	// 	result = append(result, x)
	// }

	var result = make([][]string, len(xlinks))
	for i, v := range xlinks {
		var x = []string{fmt.Sprintf("%d", (v[2])), ss[v[2]:v[3]], fmt.Sprintf("%d", (v[3]))}
		result[i] = x
	}

	return result
}

// transformLink change a xah http link to file full path
// eg http://ergoemacs.org/index.html becomes /Users/xah/web/ergoemacs_org/index.html
// if it's not exah site link, return no change
// version 2018-11-12
func transformLink(ss string) string {
	var xx = ss
	xx = strings.Replace(xx, "http://ergoemacs.org/", "/Users/xah/web/ergoemacs_org/", 1)
	xx = strings.Replace(xx, "http://wordyenglish.com/", "/Users/xah/web/wordyenglish_com/", 1)
	xx = strings.Replace(xx, "http://xaharts.org/", "/Users/xah/web/xaharts_org/", 1)
	xx = strings.Replace(xx, "http://xahlee.info/", "/Users/xah/web/xahlee_info/", 1)
	xx = strings.Replace(xx, "http://xahlee.org/", "/Users/xah/web/xahlee_org/", 1)
	xx = strings.Replace(xx, "http://xahmusic.org/", "/Users/xah/web/xahmusic_org/", 1)
	xx = strings.Replace(xx, "http://xahporn.org/", "/Users/xah/web/xahporn_org/", 1)
	xx = strings.Replace(xx, "http://xahsl.org/", "/Users/xah/web/xahsl_org/", 1)
	return xx
}

// checkFile, takes a html file path, extract all links, if local link and file does not exist, print it
func checkFile(path string) error {
	contentBytes, er := ioutil.ReadFile(path)
	if er != nil {
		panic(er)
	}
	var lnks = getLinks(string(contentBytes))

	for _, v := range lnks {
		var linkVal = v[1]
		var isXahSite, errxs = regexp.MatchString(`^http://ergoemacs.org|^http://wordyenglish.com|^http://xaharts.org|^http://xahlee.info|^http://xahlee.org|^http://xahmusic.org|^http://xahporn.org|^http://xahsl.org/`, linkVal)
		if errxs != nil {
			panic(errxs)
		}
		if isXahSite {
			var lnkPath = removeFrac(transformLink(linkVal))
			if !isFileExist(lnkPath) {
				fmt.Printf("%c%v%c %c%v%c %#v\n", fileBracketL, path, fileBracketR, posBracketL, v[2], posBracketR, linkVal)
			}
		} else {
			var isNoWant, errM = regexp.MatchString(`//|^http://|^https://|^mailto:|^irc:|^ftp:|^javascript:`, linkVal)
			if errM != nil {
				panic(errM)
			}
			if !isNoWant {
				var noFrag = removeFrac(linkVal)
				var linkedPath = filepath.Dir(path) + "/" + noFrag
				linkedPath = filepath.Clean(linkedPath)
				if !isFileExist(linkedPath) {
					fmt.Printf("%c%v%c %c%v%c %#v\n", fileBracketL, path, fileBracketR, posBracketL, v[1], posBracketR, noFrag)
				}
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

	inDir = filepath.Dir(inDir)

	fmt.Println("-*- coding: utf-8; mode: xah-find-output -*-")
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
				checkFile(pathX)
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
