import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/31.dart';

class CreativecreatorormaybenotFunvas31Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas31Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: ThirtyOne()),
      ),
    );
  }
}
