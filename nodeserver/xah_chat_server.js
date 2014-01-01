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
var rooms = {"lobby":{},"lounge":{}};
var defaultRoom = "lobby";

var cmds = ["rooms","join", "leave", "quit", "help"];

var welcomeMsg = "welcome gc!\nType /help to see commands.\n";
var helpMsg = "/" + cmds.join("\n/") + "\n";

var nicknames = {};

var checkNickTaken = function (inputNick) {
    return socketList.some(function (x) { if ( x.nickname === inputNick ) {return true;} })
}

var printRooms = function (skt) {
    Object.keys(rooms).forEach(function (x) {
        (x === skt["room"]) ?
            skt.write(" * " + x + "\n") :
            skt.write("   " + x + "\n") ;
    })
}

var listPeopleInRoom = function (skt, room) {
    socketList.forEach(function (x) {
        if ( x["room"] === room && x !== skt) {
            skt.write( x["nickname"] + "\n");
        } }) }

// remove chars that's not ascii alphnumeric, and chop to length 10
var filterChars = function (inputNick) { return inputNick.trim().slice(0,10).replace(/[\W]/g, ""); }

var inputHandler = function (dataBuf, skt) {

    if ( ! skt.hasOwnProperty("nickname") ) {
        var newNick = filterChars(dataBuf.toString());
        if ( checkNickTaken(newNick) || newNick.length < 1 ) {
            skt.write("Sorry, nickname " + newNick + "taken. Type 1 to 10 chars. Try another.");
        } else {
            skt.nickname = newNick;
            skt.write("your nick is now:" + skt.nickname + "\n");
            skt.write(skt.nickname + ">");
            return;
        } }

    if ( dataBuf.toString().trim() === "/help" ) {
        skt.write(helpMsg);
        skt.write(skt.nickname + ">");
        return;
    }

    if ( dataBuf.toString().trim() === "/rooms" ) {
        printRooms(skt);
        skt.write(skt.nickname + ">");
        return;
    }

    if ( dataBuf.toString().trim() === "/quit" ) {
        skt.destroy();
        return;
    }

    if ( dataBuf.toString().trim() === "/leave" ) {
        skt["room"] = defaultRoom;
        skt.write("You are back in " + defaultRoom + "\n");
        skt.write(skt.nickname + ">");
        return;
    }

    if ( dataBuf.toString().search(/^\/join/) !== -1 ) {
        var roomName = (dataBuf.toString().trim().split(/ +/))[1];
        // roomName = filterChars(roomName);

        // skt.write("room is [" + roomName + "]\n");

        if ( ! roomName ) {
            skt.write("type /join <roomName> to join a room. Valid rooms are:\n");
            printRooms(skt);
        }
        else if ( ! rooms.hasOwnProperty(roomName) ) {
            skt.write("room [" + roomName + "] not valid. Valid rooms are:\n");
            printRooms(skt);
        }
        else {
            skt["room"] = roomName;
            skt.write("joined room:" + roomName + "\n");
            listPeopleInRoom(skt, roomName);
        }

        skt.write(skt.nickname + ">");
        return;
    }

    // broadcast to all in the same room, except self
    for (var i = 0; i < socketList.length; i++) {
        if ( socketList[i] === skt ) { 
            skt.write(skt.nickname + ">");
            continue; }
        else {
            if ( socketList[i]["room"] === skt["room"] ) {
                socketList[i].write(skt.nickname + ":" + dataBuf);
            }
        }
    } }

var connectionHandler = function (xxsocket) {
    console.log("server connected");

    xxsocket["room"] = defaultRoom;
    socketList.push(xxsocket);

    xxsocket.write(welcomeMsg);
    xxsocket.write(helpMsg);


    xxsocket.write("Type a nickname.\n");

    xxsocket.on("data", function (x) { inputHandler(x, xxsocket)});

    xxsocket.on("end", function () {
        var i = socketList.indexOf(xxsocket);
        socketList.splice(i,1); //delete that one
        console.log("server disconnected");
    });
}

var myServer = xnet.createServer(connectionHandler);

myServer.listen(xPort, xIP);
