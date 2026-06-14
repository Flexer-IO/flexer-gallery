import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/11.dart';

class CreativecreatorormaybenotFunvas11Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas11Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Eleven()),
      ),
    );
  }
}
