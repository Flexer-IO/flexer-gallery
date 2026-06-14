import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/27.dart';

class CreativecreatorormaybenotFunvas27Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas27Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: TwentySeven()),
      ),
    );
  }
}
