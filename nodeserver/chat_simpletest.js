// -*- coding: utf-8 -*-


var xx = function(c) { //'connection' listener
    console.log('server connected');
    c.on('end', function() {
        console.log('server disconnected');
    });
    c.write('hi \r\n' + typeof c);
    c.pipe(c);
}

var net = require('net');
var server = net.createServer(xx);

server.listen(8124, function() { //'listening' listener
    console.log('server bound');
});
