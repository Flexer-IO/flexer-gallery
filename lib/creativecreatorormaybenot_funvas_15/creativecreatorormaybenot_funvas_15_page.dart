import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/15.dart';

class CreativecreatorormaybenotFunvas15Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas15Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Fifteen()),
      ),
    );
  }
}
