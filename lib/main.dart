import 'package:flutter/material.dart';
import 'main_game.dart';
import 'connect_game.dart';
import 'game.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tic Tac Toe',
      theme: new ThemeData(
        fontFamily: 'GT',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isConnected = false;
  var mainGameWidget;
  Game game = new Game();
  List<List<int>> gameBoard = [];
  String opponentName;
  bool isSideDecided = false;
  int move = 0;
  bool isYourTurn = false;
  bool isGameOver = false;
  bool haveYouLost=false;
  String gameOverText = "";
  int yourScore=0,opponentScore=0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    mainGameWidget = MainGame(game, gameBoard, opponentName, isSideDecided,
        move, isYourTurn, isGameOver, gameOverText,yourScore,opponentScore,haveYouLost,(yourSc,opponentSc){
          
            yourScore=yourSc;
            opponentScore=opponentSc;            
          
        });
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Tic Tac Toe Online Multiplayer',
          style: TextStyle(color: Color(0xFF365075)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Builder(
        builder: (context) {
          return isConnected
              ? mainGameWidget
              : ConnectGame(
                  callback: (map) {
                    int side = map["which"];
                    if (side == -1) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('You have got side - O'),
                      ));
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('You have got side - X'),
                      ));
                    }
                    setState(() {
                      this.isConnected = map["isConnected"];
                      this.isSideDecided = map["isSideDecided"];
                      this.move = map["which"];
                      this.opponentName = map["name"];
                      this.isYourTurn = map["isYourTurn"];
                    });
                  },
                  callbackForGrid: (grid, iYT) {
                    setState(() {
                      print("setting gameBoard from callback");
                      gameBoard = grid;
                      game.board = grid; 
                      print(gameBoard);
                      print(game.board);
                      isYourTurn = iYT;
                      Map gameOverMap = game.isGameOver();
                      print(gameOverMap);
                      if (gameOverMap != null) {
                        isGameOver = true;
                        if (move == gameOverMap["which"]) {
                          gameOverText = "You Won!!";
                          yourScore=yourScore+1;
                          opponentScore=opponentScore;
                          print("scores match you own ${yourScore} ${opponentScore}");
                          isYourTurn=false;
                        } else {
                          opponentScore=opponentScore+1;
                          yourScore=yourScore;
                          print("scores match lost ${yourScore} ${opponentScore}");
                          haveYouLost=true;
                          gameOverText = "${opponentName} Won!!";
                        }
                      }else {
                        isGameOver=false;
                        haveYouLost=false;
                        print("scores not game over/reset ${yourScore} ${opponentScore}");
                        yourScore=yourScore;
                        opponentScore=opponentScore;
                      }
                    });
                  },isConnecting: false,
                );
        },
      ),
    );
  }
}
