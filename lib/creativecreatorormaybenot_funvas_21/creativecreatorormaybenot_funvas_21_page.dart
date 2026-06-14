import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/21.dart';

class CreativecreatorormaybenotFunvas21Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas21Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: TwentyOne()),
      ),
    );
  }
}
