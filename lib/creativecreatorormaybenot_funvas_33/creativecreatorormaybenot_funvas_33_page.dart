import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/33.dart';

class CreativecreatorormaybenotFunvas33Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas33Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: ThirtyThree()),
      ),
    );
  }
}
