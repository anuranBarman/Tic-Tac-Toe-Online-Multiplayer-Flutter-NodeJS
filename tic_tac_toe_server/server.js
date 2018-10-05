const dgram = require('dgram');
const server = dgram.createSocket('udp4');
var connectionIds = [];
var connectionMap = {};
server.on('error', (err) => {
  console.log(`server error:\n${err.stack}`);
  server.close();
});

server.on('message', (msg, rinfo) => {
  console.log(`server got: ${msg} from ${rinfo.address}:${rinfo.port}`);
  const json = JSON.parse(msg);
  json["host"]=rinfo.address;
  json["port"]=rinfo.port;
  if(json["type"]== "0"){
    connectionIds.push(json);
    console.log(connectionIds);
  
    if(connectionIds.length%2==0){
        for(var i =0;i<connectionIds.length-1;i+=2){
            const cnIdFirst = connectionIds[i];
            const cnIdSecond = connectionIds[i+1];
            const response = {
                type:0,
                msg:`${cnIdSecond.name}`,
                which:0
            }
            var randomNumber = Math.random();
            if(randomNumber >= 0.9){
                response.which=1;
            }else {
                response.which=-1;
            }
            console.log(`response which ${response.which}`);
            
            server.send(JSON.stringify(response),cnIdFirst.port,cnIdFirst.host);
            response.msg = `${cnIdFirst.name}`;
            response.which = response.which == 1 ? -1 : 1;
            console.log(`response which ${response.which}`);
            server.send(JSON.stringify(response),cnIdSecond.port,cnIdSecond.host);
            console.log('sent');
            connectionMap[cnIdFirst.id+""]=cnIdSecond;
            connectionMap[cnIdSecond.id+""]=cnIdFirst;
            console.log(connectionMap);
            delete connectionIds[i];
            delete connectionIds[i+1];
            
        }
        
    }else {
        const response = {
            type:-1,
            msg:`Waiting for other players to connect`
        }
        server.send(JSON.stringify(response),rinfo.port,rinfo.address);
    }
  }else if(json["type"]=="2"){
    var arrForResponse = {};
    var counter=0;
    for(var i=0;i<3;i++){
        for(var j=0;j<3;j++){
            arrForResponse[`${counter}`]=json[`${counter}`]
            counter++;
        }
    }

    var id = json["id"];
    console.log('id '+id);
    
    const response = {
        type:2,
        isYourTurn:true,
        msg:arrForResponse
    }
    var connectionId = connectionMap[id];
    server.send(JSON.stringify(response),connectionId.port,connectionId.host);
  }
  
  
});

server.on('listening', () => {
  const address = server.address();
  console.log(`server listening ${address.address}:${address.port}`);
});

server.bind(41234,"192.168.43.31");