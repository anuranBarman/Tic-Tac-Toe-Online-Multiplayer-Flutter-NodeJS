import 'dart:io';
import 'dart:convert';
import 'nanoid/nanoid.dart';

class UDPHandler {
  static RawDatagramSocket socket;
  static String address = "192.168.43.31";
  static int port = 41234;
  static String id;

  static void connect(String address, int port, Map dataRaw, Function callback,
      Function callbackForGrid) {
    var data = dataRaw;
    id = nanoid();
    data["id"] = id;
    var codec = new Utf8Codec();
    List<int> dataToSend = codec.encode(jsonEncode(data));
    var addressesIListenFrom = InternetAddress.ANY_IP_V4;
    int portIListenOn = 0; //0 is random
    RawDatagramSocket.bind(addressesIListenFrom, portIListenOn)
        .then((RawDatagramSocket udpSocket) {
      socket = udpSocket;
      udpSocket.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.READ) {
          Datagram dg = udpSocket.receive();
          List<int> data = [];
          dg.data.forEach((x) => data.add(x));
          String decodedData = utf8.decode(data);
          Map<String, dynamic> map = jsonDecode(decodedData);
          if (map["type"] == -1) {
          } else if (map["type"] == 0) {
            Map map2 = new Map();
            map2["isConnected"] = true;
            map2["name"] = map["msg"];
            map2["isSideDecided"] = true;
            map2["which"] = map["which"];
            map2["isYourTurn"] = map["which"] == 1 ? true : false;
            callback(map2);
          } else if (map["type"] == 2) {
            print("type 2 msg came");
            print(map);
            Map<String, dynamic> msg = map["msg"];
            List<List<int>> grid = [];
            int counter = 0;
            for (int i = 0; i < 3; i++) {
              List<int> column = [];
              for (int j = 0; j < 3; j++) {
                column.add(msg["${counter}"] as int);
                counter++;
              }
              grid.add(column);
            }
            print("sending grid ${grid}");
            bool isYourTurn = map["isYourTurn"];
            callbackForGrid(grid, isYourTurn);
          }
        }
      });
      udpSocket.send(dataToSend, new InternetAddress(address), port);
      print('Did send data on the stream..');
    });
  }

  static bool isReset(List<List<int>> grid) {
    bool isReset = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if(grid[i][j]!=0){
          isReset=false;
        } 
      }
    }
    return isReset;
  }

  static sendGrid(Map dataRw) {
    var data = dataRw;
    data["id"] = id;
    print("sending id ${id}");
    var codec = new Utf8Codec();
    List<int> dataToSend = codec.encode(jsonEncode(data));
    socket.send(dataToSend, new InternetAddress(address), port);
  }
}
