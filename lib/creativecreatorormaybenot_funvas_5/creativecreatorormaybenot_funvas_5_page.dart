import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/5.dart';

class CreativecreatorormaybenotFunvas5Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas5Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Five()),
      ),
    );
  }
}
