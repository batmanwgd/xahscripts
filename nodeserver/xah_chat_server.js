// -*- coding: utf-8 -*-
// basic chat client

var xPort = 9399;
var xIP = "127.0.0.1";
var xIP = "162.243.151.192";

var xnet = require('net');

// each socket needs a nickname, and its room.

var socketList = [];
var rooms = {"lobby":0, "lounge":0}; // key is room name, value is number of people
var defaultRoom = "lobby";

var cmds = ["rooms","join", "leave", "quit", "help", "whoshere"];

var welcomeMsg = "welcome gc!\nType /help to see commands.\n";
var helpMsg = "/" + cmds.join("\n/") + "\n";

var nicknames = {};

var checkNickTaken = function (inputNick) {
    return socketList.some(function (x) { if ( x.nickname === inputNick ) {return true;} })
}

// recompute the number of people in rooms. That is, set the rooms object's values.
var recomputeRooms = function () {
    Object.keys(rooms).forEach(function (rname) { rooms[rname] = 0;});
    socketList.forEach(function (sockk) { rooms[sockk["room"]]++; } )
}

// print room names with number of people in it
var printRooms = function (skt) {
    Object.keys(rooms).forEach(function (rmName) {
        if (skt["room"] === rmName) {
            skt.write(" * " + rmName + " (" + rooms[rmName] + ")\n");
        } else {
            skt.write("   " + rmName + " (" + rooms[rmName] + ")\n");
        }
    })
}

// list people in a given room
// print to socket.
// skt is socket. room is room name
var listPeopleInRoom = function (skt, room) {
    socketList.forEach(function (x) {
        if ( x["room"] === room) {
            skt.write( x["nickname"] + "\n");
        } }) }

// remove chars that's not ascii alphnumeric, and chop to length 10
var filterChars = function (inputNick) { return inputNick.trim().slice(0,10).replace(/[\W]/g, ""); }

var inputHandler = function (dataBuf, skt) {

    if ( ! skt.hasOwnProperty("nickname") ) {
        var newNick = filterChars(dataBuf.toString());

        if ( newNick.length < 1 ) {
            skt.write("Type a nickname.\n");
            return;
        }
        else if ( checkNickTaken(newNick)) {
            skt.write("Sorry, nickname [" + newNick + "] already taken. Type 1 to 10 chars. Try another.\n");
            return;
        }
        else if ( cmds.indexOf(newNick) !== -1 ) {
            skt.write("Sorry, nickname [" + newNick + "] cannot be the same as command name. Try another.\n");
            return;
        }
        else {
            skt.nickname = newNick;
            skt.write("your nick is now: " + skt.nickname + "\n");
            skt.write(helpMsg);
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
        console.log("Disconnected from: " + skt.remoteAddress + " " + skt.remotePort);
        skt.destroy();
        return;
    }

    if ( dataBuf.toString().trim() === "/leave" ) {
        skt["room"] = defaultRoom;
        skt.write("You are back in " + defaultRoom + "\n");
        skt.write(skt.nickname + ">");
        return;
    }

    if ( dataBuf.toString().trim() === "/whoshere" ) {
        listPeopleInRoom(skt, skt["room"] );
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
            skt.write("joined room: " + roomName + "\n");
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
    console.log("Connected from: " + xxsocket.remoteAddress + " " + xxsocket.remotePort);

    xxsocket["room"] = defaultRoom;
    recomputeRooms();
    socketList.push(xxsocket);
    xxsocket.write(welcomeMsg);
    xxsocket.write("Type a nickname.\n");

    xxsocket.on("data", function (x) { inputHandler(x, xxsocket)});

    xxsocket.on("end", function () {
        var i = socketList.indexOf(xxsocket);
        console.log("Disconnected from: " + socketList[i].remoteAddress + " " + socketList[i].remotePort);
        socketList.splice(i,1); //delete that one
    });
}

var myServer = xnet.createServer(connectionHandler);

myServer.listen(xPort, xIP);
