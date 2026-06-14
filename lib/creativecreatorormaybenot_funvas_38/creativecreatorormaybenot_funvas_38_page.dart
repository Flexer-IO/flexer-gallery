import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/38.dart';

class CreativecreatorormaybenotFunvas38Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas38Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: ThirtyEight()),
      ),
    );
  }
}
