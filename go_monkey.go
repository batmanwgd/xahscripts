package main

/*
// 2019-06-17
go thru a list of text files. for each file, open it, grab part of the content. insert that content into a corresponding file.
*/

import "fmt"
import "io/ioutil"
import "strings"

var dirSrc = "/Users/xah/web/wordyenglish_com/monkey_king/"

var fileList = []string{
"xx001-2.html",
"xx002-2.html",
"xx003-2.html",
"xx004-2.html",
"xx005-2.html",
"xx006-2.html",
"xx007-2.html",
"xx008-2.html",
"xx009-2.html",
"xx010-2.html",
"xx011-2.html",
"xx012-2.html",
"xx013-2.html",
"xx014-2.html",
"xx015-2.html",
"xx016-2.html",
"xx017-2.html",
"xx018-2.html",
"xx019-2.html",
"xx020-2.html",
"xx021-2.html",
"xx022-2.html",
"xx023-2.html",
"xx024-2.html",
"xx025-2.html",
"xx026-2.html",
"xx027-2.html",
"xx028-2.html",
"xx029-2.html",
"xx030-2.html",
"xx031-2.html",
"xx032-2.html",
"xx033-2.html",
"xx034-2.html",
"xx035-2.html",
"xx036-2.html",
"xx037-2.html",
"xx038-2.html",
"xx039-2.html",
"xx040-2.html",
"xx041-2.html",
"xx042-2.html",
"xx043-2.html",
"xx044-2.html",
"xx045-2.html",
"xx046-2.html",
"xx047-2.html",
"xx048-2.html",
"xx049-2.html",
"xx050-2.html",
"xx051-2.html",
"xx052-2.html",
"xx053-2.html",
"xx054-2.html",
"xx055-2.html",
"xx056-2.html",
"xx057-2.html",
"xx058-2.html",
"xx059-2.html",
"xx060-2.html",
"xx061-2.html",
"xx062-2.html",
"xx063-2.html",
"xx064-2.html",
"xx065-2.html",
"xx066-2.html",
"xx067-2.html",
"xx068-2.html",
"xx069-2.html",
"xx070-2.html",
"xx071-2.html",
"xx072-2.html",
"xx073-2.html",
"xx074-2.html",
"xx075-2.html",
"xx076-2.html",
"xx077-2.html",
"xx078-2.html",
"xx079-2.html",
"xx080-2.html",
"xx081-2.html",
"xx082-2.html",
"xx083-2.html",
"xx084-2.html",
"xx085-2.html",
"xx086-2.html",
"xx087-2.html",
"xx088-2.html",
"xx089-2.html",
"xx090-2.html",
"xx091-2.html",
"xx092-2.html",
"xx093-2.html",
"xx094-2.html",
"xx095-2.html",
"xx096-2.html",
"xx097-2.html",
"xx098-2.html",
"xx099-2.html",
"xx100-2.html",
}

func main() {

	for _, fname := range fileList {
		var fullpath = dirSrc + fname

		// read whole file
		page2, myErr := ioutil.ReadFile(fullpath)
		if myErr != nil {
			panic(myErr)
		}

		// grab the main content of the file (for example, we do not care for header and footer )
		// the main content will be deliminated by <main> and </main>

		var startPos = strings.Index(string(page2), "</h1>") + 5
		var endPos = strings.Index(string(page2), `<div class="ads-bottom-65900">`)
		var mainContent = page2[startPos:endPos]

		var chapterFileName = fname[0:5]

		// read whole file
		page1, myErr2 := ioutil.ReadFile(dirSrc + chapterFileName + "-1.html")
		if myErr2 != nil {
			panic(myErr2)
		}

		var insertPos = strings.Index(string(page1), `<div class="ads-bottom-65900">`)

		var textBefore = page1[:insertPos]
		var textAfter = page1[insertPos:]

		var newText = make([]byte, 0, len(page1)*3)

		newText = append(newText, textBefore...)
		newText = append(newText, mainContent...)
		newText = append(newText, textAfter...)

		err := ioutil.WriteFile(dirSrc + chapterFileName[1:] + "-1.html", newText, 0644)
		if err != nil {
			panic(err)
		}

	}
	fmt.Println("done")
}
