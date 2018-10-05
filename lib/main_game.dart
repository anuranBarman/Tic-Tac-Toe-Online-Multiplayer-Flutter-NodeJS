import 'package:flutter/material.dart';
import 'game.dart';
import 'gridwidget.dart';
import 'udphandler.dart';


typedef ScoreCallback(int yourScore,int opponentScore);

class MainGame extends StatefulWidget {
  Game game;
  List<List<int>> gameBoardGrid;
  String opponentName = "";
  bool isSideDecided = false;
  bool isYourTurn;
  int move;
  int yourScore=0;
  int opponentScore=0;
  bool isGameOver = false;
  bool haveYouLost=false;
  String gameOverText = "";
  ScoreCallback scoreCallback;
  MainGame(this.game, this.gameBoardGrid, this.opponentName, this.isSideDecided,
      this.move, this.isYourTurn,this.isGameOver,this.gameOverText,this.yourScore,this.opponentScore,this.haveYouLost,this.scoreCallback);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainGameState();
  }
}

class MainGameState extends State<MainGame> {
  // -1 is 0 , 1 is X

  List<Widget> getGameBoardWidget() {
    widget.gameBoardGrid = widget.game.getGameBoard();
    List<Widget> gameBoard = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        gameBoard.add(GestureDetector(
          child: GridWidget(widget.gameBoardGrid[i][j], widget.game, [i, j]),
          onTap: () {
            if (widget.isSideDecided && widget.isYourTurn) {
              setState(() {
                widget.isYourTurn = false;
                widget.game.setPlayerMove(widget.move, i, j);
                widget.gameBoardGrid = widget.game.getGameBoard();
                Map gameOverMap = widget.game.isGameOver();
                if (gameOverMap != null) {
                  widget.isGameOver = true;
                  if (widget.move == gameOverMap["which"]) {
                    widget.gameOverText = "You Won!!";
                    widget.yourScore+=1;
                    widget.opponentScore=widget.opponentScore;
                    print("scores local won ${widget.yourScore} ${widget.opponentScore}");
                    widget.isYourTurn=false;
                  } else {
                    widget.opponentScore+=1;
                    widget.yourScore=widget.yourScore;
                    print("scores local lost ${widget.yourScore} ${widget.opponentScore}");
                    widget.haveYouLost=true;
                    widget.gameOverText = "${widget.opponentName} Won!!";
                  }
                }
                Map<String, dynamic> map = new Map();
                map["type"] = "2";
                map["isYourTurn"]=true;
                int counter = 0;
                for (int i = 0; i < widget.gameBoardGrid.length; i++) {
                  for (int j = 0; j < 3; j++) {
                    map["${counter}"] = widget.gameBoardGrid[i][j];
                    counter++;
                  }
                }
                sendGrid(map);
                widget.scoreCallback(widget.yourScore,widget.opponentScore);
              });
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('This is not your turn fella!'),
              ));
            }
          },
        ));
      }
    }
    return gameBoard;
  }

  void sendGrid(Map dataRaw) async {
    UDPHandler.sendGrid(dataRaw);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'You',
                  style: TextStyle(
                      color: Color(0xFF365075),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          '${widget.yourScore}',
                          style: TextStyle(
                              color: Color(0xFF365075),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' - ',
                          style: TextStyle(
                              color: Color(0xFF365075),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' ${widget.opponentScore}',
                          style: TextStyle(
                              color: Color(0xFF365075),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  elevation: 4.0,
                ),
                Text(
                  '${widget.opponentName}',
                  style: TextStyle(
                      color: Color(0xFF365075),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
              height: MediaQuery.of(context).size.width - 40,
              child: Card(
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.grey,
                    ),
                    GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      children: getGameBoardWidget(),
                    ),
                    widget.isGameOver
                        ? Container(
                            color: Color(0xFF365075),
                            child: Center(
                              child: Text(
                                '${widget.gameOverText}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
                elevation: 4.0,
              ),
            ),
          ),
          (widget.isGameOver && widget.haveYouLost) ? Padding(
            padding: EdgeInsets.all(20.0),
            child: RaisedButton(
              child: Text('Replay', style: TextStyle(color: Colors.white)),
              color: Color(0xFF365075),
              onPressed: (){
                setState(() {
                  widget.game.resetBoard();
                  widget.gameBoardGrid = widget.game.getGameBoard();
                  widget.isGameOver=false;
                  widget.haveYouLost=false;
                  widget.yourScore=widget.yourScore;
                  widget.opponentScore=widget.opponentScore;
                  widget.isYourTurn = widget.move == 1 ? false:true;
                  Map<String, dynamic> map = new Map();
                  map["type"] = "2";
                  map["isYourTurn"]=!widget.isYourTurn;
                  int counter = 0;
                  for (int i = 0; i < widget.gameBoardGrid.length; i++) {
                    for (int j = 0; j < 3; j++) {
                      map["${counter}"] = widget.gameBoardGrid[i][j];
                      counter++;
                    }
                  }
                  sendGrid(map);                  
                });
              },
            ),
          ) : SizedBox()
        ],
      ),
    );
  }
}
