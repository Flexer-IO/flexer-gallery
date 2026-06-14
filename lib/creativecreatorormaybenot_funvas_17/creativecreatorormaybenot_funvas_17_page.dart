import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/17.dart';

class CreativecreatorormaybenotFunvas17Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas17Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Seventeen()),
      ),
    );
  }
}
