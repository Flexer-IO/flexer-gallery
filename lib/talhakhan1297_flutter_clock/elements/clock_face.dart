import 'package:flutter/material.dart';
import 'tickers.dart';

class ClockFace extends StatelessWidget {
  const ClockFace({
    Key? key,
    this.color,
    this.width,
    required this.datetime,
    required this.darkTheme,
    this.tickColor,
  }) : super(key: key);

  final Color? color;
  final double? width;
  final DateTime datetime;
  final Color? tickColor;
  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    final w = width ?? 300.0;
    final c = color ?? Colors.white;
    final tc = tickColor ?? Colors.black;
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: w - 20,
                height: w - 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: darkTheme ? 0 : 2.5,
                      blurRadius: darkTheme ? 20 : 30,
                      color: darkTheme
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.white,
                      offset: const Offset(-10, -10),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: w - 30,
                height: w - 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 30,
                      color: darkTheme
                          ? Colors.black.withValues(alpha: 0.5)
                          : Colors.black.withValues(alpha: 0.18),
                      offset: const Offset(10, 10),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: w,
            height: w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: c),
          ),
          SizedBox(
            width: w - 8,
            height: w - 8,
            child: CustomPaint(
              painter: TickerPainter(datetime: datetime, tickColor: tc),
            ),
          ),
        ],
      ),
    );
  }
}
