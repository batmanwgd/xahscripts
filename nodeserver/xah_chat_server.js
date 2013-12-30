// -*- coding: utf-8 -*-
// simple chat client

// ask user for login name, not same as existing
// command to list rooms, with number of users in that room
// 「/rooms」
// 「/join roomname」 join a room
// when user joins a room, list all user names
// 「/leave」 leave room
// 「/quit」 disconnect

var xPort = 9399;
var xIP = "127.0.0.1";

var xnet = require('net');

// each socket needs a nickname, and its room.

var socketList = [];
var rooms = {"general":{},"lounge":{}};
var cmds = ["rooms","join", "leave", "quit", "help"];

var welcomeMsg = "welcome gc_reviewer!\nType /help to see commands.\n";
var helpMsg = "/" + cmds.join("\n/") + "\n";

var nicknames = {};


var handleConnect = function (xxsocket) {
    console.log("server connected");
    xxsocket.write(welcomeMsg);
    xxsocket.write(helpMsg);

    // if ( ! xxsocket.hasOwnProperty("nickname") ) {
    //     xxsocket.write("type a nickname.");
    // }

    socketList.push(xxsocket);

    xxsocket.on("data", function (dataBuf) {

        // xxsocket.write( "♥ " + dataBuf.toString()); // echo

        if ( dataBuf.toString().trim() === "/help" ) {
            xxsocket.write(helpMsg);
            return;
        }

        if ( dataBuf.toString().trim() === "/rooms" ) {
            xxsocket.write(Object.keys(rooms).join("\n") + "\n");
            return;
        }

        // broadcast to all except self
        for (var i = 0; i < socketList.length; i++) {
            if ( socketList[i] == xxsocket ) { continue; }
            socketList[i].write(dataBuf);
        }
    });

    xxsocket.on("end", function () {
        var i = socketList.indexOf(xxsocket);
        socketList.splice(i,1); //delete that one
        console.log("server disconnected");
    });

}

var myServer = xnet.createServer(handleConnect);

myServer.listen(xPort, xIP);
