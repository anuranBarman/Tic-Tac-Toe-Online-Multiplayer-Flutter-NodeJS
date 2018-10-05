import 'package:flutter/material.dart';
import 'game.dart';

class GridWidget extends StatefulWidget {
  final int number;
  final Game game;
  final List<int> index;

  GridWidget(this.number, this.game, this.index);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GridState();
  }
}

class GridState extends State<GridWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: (MediaQuery.of(context).size.width-44)/3,
      height: (MediaQuery.of(context).size.width-44)/3,
      color: Colors.white,
      child: Center(
        child: widget.number == 0 ? SizedBox() : (widget.number == -1 ? Image.asset("zero.png") : Image.asset("cross.png")),
      ),
    );
  }
}
