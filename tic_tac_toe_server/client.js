var dgram = require('dgram');
var s = dgram.createSocket('udp4');
s.send(Buffer.from('abc'), 41234, '192.168.2.13');