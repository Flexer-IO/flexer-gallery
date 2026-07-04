import 'package:flutter/material.dart';
import 'mycolor.dart';

class Tile extends StatefulWidget {
  final String number;
  final double width;
  final double height;
  final int color;
  final double size;

  const Tile(this.number, this.width, this.height, this.color, this.size, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          widget.number,
          style: TextStyle(
            fontSize: widget.size,
            fontWeight: FontWeight.bold,
            color: Color(MyColor.fontColorTwoFour),
          ),
        ),
      ),
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Color(widget.color),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }
}