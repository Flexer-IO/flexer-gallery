import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/8.dart';

class CreativecreatorormaybenotFunvas8Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas8Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Eight()),
      ),
    );
  }
}
