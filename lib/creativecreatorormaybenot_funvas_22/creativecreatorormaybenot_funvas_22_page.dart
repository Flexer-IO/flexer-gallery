import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/22.dart';

class CreativecreatorormaybenotFunvas22Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas22Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: TwentyTwo()),
      ),
    );
  }
}
