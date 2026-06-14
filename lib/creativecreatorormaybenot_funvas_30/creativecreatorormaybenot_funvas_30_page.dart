import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/30.dart';

class CreativecreatorormaybenotFunvas30Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas30Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Thirty()),
      ),
    );
  }
}
