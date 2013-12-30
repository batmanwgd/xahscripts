// -*- coding: utf-8 -*-
process.stdin.resume();
process.stdin.setEncoding('utf8');

process.stdin.on('data', function(chunk) {
  process.stdout.write(decodeURIComponent(chunk));
});
