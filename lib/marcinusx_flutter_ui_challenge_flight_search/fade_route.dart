import 'package:flutter/material.dart';

class FadeRoute<T> extends MaterialPageRoute<T> {
  FadeRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 100);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // If this is the initial route (i.e., there is no previous route to pop back to),
    // return the child without applying a fade transition.
    if (!Navigator.of(context).canPop()) return child;
    return FadeTransition(opacity: animation, child: child);
  }
}