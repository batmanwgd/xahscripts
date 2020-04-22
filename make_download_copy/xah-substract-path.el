;; 2018-09-13

(defun xah-substract-path (@path1 @path2)
  "Remove string @path2 from the beginning of @path1.
length of @path1 ≥ to length @path2.

path1
c:/Users/lisa/web/a/b

path2
c:/Users/lisa/web/

result
a/b

This is the similar to emacs 24.4's `string-remove-prefix' from (require 'subr-x), but the args are reversed.
Version 2015-12-15, 2018-09-13"
  (let (($p2length (length @path2)))
    (if (string-equal (substring @path1 0 $p2length) @path2 )
        (substring @path1 $p2length)
      (error "error 34689: beginning doesn't match: 「%s」 「%s」" @path1 @path2))))


;; (xah-substract-path "c:/Users/lisa/web/a/b" "c:/Users/lisa/web/")

;; (require 'subr-x)
;; (string-remove-prefix "c:/Users/lisa/web/" "c:/Users/lisa/web/a/b")



