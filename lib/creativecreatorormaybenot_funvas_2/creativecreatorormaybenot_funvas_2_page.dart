import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/2.dart';

class CreativecreatorormaybenotFunvas2Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(aspectRatio: 1, child: FunvasContainer(funvas: Two())),
    );
  }
}
