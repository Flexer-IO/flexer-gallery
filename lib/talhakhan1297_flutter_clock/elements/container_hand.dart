import 'package:flutter/material.dart';
import 'hand.dart';

class ContainerHand extends Hand {
  const ContainerHand({
    required Color color,
    required double size,
    required double angleRadians,
    this.child,
  }) : super(color: color, size: size, angleRadians: angleRadians);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: Transform.rotate(
          angle: angleRadians,
          alignment: Alignment.center,
          child: Transform.scale(
            scale: size,
            alignment: Alignment.center,
            child: Container(
              color: color,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
