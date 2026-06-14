import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/16.dart';

class CreativecreatorormaybenotFunvas16Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas16Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Sixteen()),
      ),
    );
  }
}
