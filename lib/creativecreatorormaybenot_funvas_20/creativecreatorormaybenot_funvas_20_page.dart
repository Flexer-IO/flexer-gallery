import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/20.dart';

class CreativecreatorormaybenotFunvas20Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas20Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Twenty()),
      ),
    );
  }
}
