// 2018-09-15

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
	inDir        = "/Users/xah/xsiteout/xahlee_info/"
	fnameRegex   = `\.html$`
)

var dirsToSkip = []string{".git"}

var frPairs = []frPair{

	frPair{
		fs: `<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
ga('create', 'UA-10884311-1', 'auto');
ga('send', 'pageview');
</script>`,
		rs: ``,
	},

	frPair{
		fs: `<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({
          google_ad_client: "ca-pub-5125343095650532",
          enable_page_level_ads: true
     });
</script>`,
		rs: ``,
	},

	frPair{
		fs: `<div class="google_ad_right_30226">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- xlinfo_right_autosize_20171107 -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="9711764997"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>`,
		rs: ``,
	},


	frPair{
		fs: `<div class="ad_top_39054">
<div class="google_ad_top_29890">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- xlinfo_top_autosize_20171107 -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="2984018199"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
</div>`,
		rs: ``,
	},


	frPair{
		fs: `<div class="ads-bottom-65900">
<div class="google_ad_bottom_e7e59">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- xlinfo_ad_bottom_20171117 -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5125343095650532"
     data-ad-slot="4412368092"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
</div>`,
		rs: ``,
	},


	frPair{
		fs: `<div class="ask_68256"><p>If you have a question, put $5 at <a class="sorc" href="https://www.patreon.com/xahlee" data-accessed="2017-08-01">patreon</a> and message me.</p></div>`,
		rs: ``,
	},


	frPair{
		fs: `<div id="disqus_thread"></div>
<script>
(function() {
var d = document, s = d.createElement('script');
s.src = 'https://xahlee.disqus.com/embed.js';
s.setAttribute('data-timestamp', +new Date());
(d.head || d.body).appendChild(s);
})();
</script>`,
		rs: ``,
	},


	frPair{
		fs: `<div class="buy-js-33416">
Liket it? Put $5 at
<a class="sorc" href="https://www.patreon.com/xahlee" data-accessed="2017-08-01">patreon</a>.<br />
<br />
Or, <a href="buy_xah_js_tutorial.html">Buy JavaScript in Depth</a>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_xclick" />
<input type="hidden" name="business" value="JPHAB7F7QZRPC" />
<input type="hidden" name="lc" value="US" />
<input type="hidden" name="item_name" value="xah JavaScript in Depth" />
<input type="hidden" name="amount" value="29.00" />
<input type="hidden" name="currency_code" value="USD" />
<input type="hidden" name="button_subtype" value="services" />
<input type="hidden" name="no_note" value="0" />
<input type="hidden" name="cn" value="Add special instructions to the seller:" />
<input type="hidden" name="no_shipping" value="1" />
<input type="hidden" name="shipping" value="0.00" />
<input type="hidden" name="bn" value="PP-BuyNowBF:btn_buynowCC_LG.gif:NonHosted" />
<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal" />
</form>
</div>`,
		rs: ``,
	},



}

type frPair struct {
	fs string // find string
	rs string // replace string
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

func doFile(path string) error {
	contentBytes, er := ioutil.ReadFile(path)
	if er != nil {
		panic(er)
	}
	var content = string(contentBytes)
	var changed = false
	for _, pair := range frPairs {
		var found = strings.Index(content, pair.fs)
		if found != -1 {
			content = strings.Replace(content, pair.fs, pair.rs, -1)
			changed = true
		}
	}
	if changed {
		fmt.Printf("〈%v〉\n", path)

		{
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

func main() {
	scriptName, errPath := os.Executable()
	if errPath != nil {
		panic(errPath)
	}

	fmt.Println("-*- coding: utf-8; mode: xah-find-output -*-")
	fmt.Printf("%v\n", time.Now())
	fmt.Printf("Script: %v\n", filepath.Base(scriptName))
	fmt.Printf("In dir: %v\n", inDir)
	fmt.Printf("File regex filter: %v\n", fnameRegex)
	fmt.Printf("Find replace pairs: 「%#v」\n", frPairs)
	fmt.Println()

	{
		err := filepath.Walk(inDir, pWalker)
		if err != nil {
			fmt.Printf("error walking the path %q: %v\n", inDir, err)
		}
	}

	fmt.Println()

	fmt.Printf("%v\n", "Done replace ad stuff.")
}
