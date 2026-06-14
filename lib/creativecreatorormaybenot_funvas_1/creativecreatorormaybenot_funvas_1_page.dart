import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/1.dart';

class CreativecreatorormaybenotFunvas1Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(aspectRatio: 1, child: FunvasContainer(funvas: One())),
    );
  }
}
