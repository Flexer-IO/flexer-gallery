import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/18.dart';

class CreativecreatorormaybenotFunvas18Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas18Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Eighteen()),
      ),
    );
  }
}
