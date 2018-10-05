class Game {
  List<List<int>> board = [];
  
  Game(){
    for(int i=0;i<3;i++){
      board.add([0,0,0]);
    }
  }

  void resetBoard(){
    for(int i=0;i<3;i++){
      for(int j=0;j<3;j++){
        this.board[i][j]=0;
      }    
    }
  }

  List<List<int>> getGameBoard(){
    return this.board;
  }

  void setPlayerMove(int move,int row,int col){
    if(this.board[row][col]==0){
      this.board[row][col]=move;
    }
  }

  Map isGameOver(){
    Map<String,dynamic> map = new Map();
    for(int i=0;i<3;i++){
        if(this.board[i][0]!=0&&this.board[i][0]==this.board[i][1] && this.board[i][1]==this.board[i][2] && this.board[i][0]==this.board[i][2]){
          map["isGameOver"]=true;
          map["which"]=this.board[i][0];
          return map;
        }
    }
    for(int j=0;j<3;j++){
        if(this.board[0][j]!=0&&this.board[0][j]==this.board[1][j] && this.board[1][j]==this.board[2][j]&&this.board[0][j]==this.board[2][j]){
          map["isGameOver"]=true;
          map["which"]=this.board[0][j];
          return map;
        }
      
    }
    if(this.board[0][0]!=0&&this.board[0][0]==this.board[1][1]&&this.board[1][1]==this.board[2][2]&&this.board[0][0]==this.board[2][2]){
      map["isGameOver"]=true;
      map["which"]=this.board[0][0];
      return map;
    }

    if(this.board[0][2]!=0&&this.board[0][2]==this.board[1][1]&&this.board[1][1]==this.board[2][0]&&this.board[0][2]==this.board[2][0]){
      map["isGameOver"]=true;
      map["which"]=this.board[0][2];
      return map;
    }

    return null;
  }

}