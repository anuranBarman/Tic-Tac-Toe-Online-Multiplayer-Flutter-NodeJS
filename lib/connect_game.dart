import 'package:flutter/material.dart';
import 'udphandler.dart';

typedef ConnectionCallback(Map map);
typedef GridCallback(List<List<int>> grid,bool isYourTurn);

class ConnectGame extends StatefulWidget {

  final ConnectionCallback callback;
  final GridCallback callbackForGrid;
  bool isConnecting=false;
  ConnectGame({this.callback,this.callbackForGrid,this.isConnecting});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ConnectGameState();
  }
}

class ConnectGameState extends State<ConnectGame> {

  final TextEditingController _controller = TextEditingController();
  void connect(String address, int port,Map dataRaw) async {
  
    UDPHandler.connect(address, port, dataRaw, widget.callback,widget.callbackForGrid);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _controller,
            maxLength: 8,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Your Nickname',
              labelStyle: TextStyle(color: Color(0xFF365075)),
            ),
          ),
          !widget.isConnecting ? Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: RaisedButton(
            child: Text('Connect', style: TextStyle(color: Colors.white)),
            color: Color(0xFF365075),
            onPressed: () {
              setState(() {
                widget.isConnecting=true;                
              });
              Map<String,String> map = new Map();
              map["name"]=_controller.text==null?"XYZ":_controller.text;
              map["type"]="0";
              connect("192.168.43.31", 41234,map);
            },
          ),
          ) : Container(
            width: MediaQuery.of(context).size.width,
            height: 100.0,
            child: Center(
            child: Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(backgroundColor: Color(0xFF365075)),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text('Connecting..', style: TextStyle(color: Color(0xFF365075))),
                )
              ],
            ),
          ),
          ),
          )
        ],
      ),
    );
  }
}
