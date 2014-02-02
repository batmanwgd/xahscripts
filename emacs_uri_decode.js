// -*- coding: utf-8 -*-
// 2014-01-11

// take a URI from stdin, percent decode it to stdout
// called from emacs

process.stdin.resume();
process.stdin.setEncoding('utf8');

process.stdin.on('data', function(chunk) {
  process.stdout.write(decodeURIComponent(chunk));
});
