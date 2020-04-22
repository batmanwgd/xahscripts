package main

import "fmt"
import "net/url"

func main() {

	var x = []string{
		"../parse_url.html#some",
		"/Users/xah/web/xahlee_info/linux/linux_swap_mouse_buttons.html#comment-3887057115",

		"../UnixResource_dir/writ/tech_geeker.html#comment-2044408048",
		"../javascript_es6/js_es6_s11.html#sec-ecmascript-language-lexical-grammar",
		"../js/recursion.html",
		"../kbd/how_many_keystrokes_programers_type_a_day.html#comment-1973054095",
		"../linux/linux_swap_mouse_buttons.html#comment-3887057115",
		"fuck_python.html#comment-2366962676",
	}

	for _, v := range x {
		var uu, err = url.Parse(v)
		if err != nil {
			panic(err)
		}

		fmt.Printf("%v\n", uu.Path)

	}

}
