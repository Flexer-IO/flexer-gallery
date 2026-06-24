import 'package:flutter/widgets.dart';

/// Propagates [TermThemeData] in the subtree.
class TermTheme extends StatelessWidget {
  const TermTheme({Key? key, required this.data, required this.child})
      : super(key: key);

  final TermThemeData data;
  final Widget child;

  static TermThemeData of(BuildContext context) {
    final widget = context.findAncestorWidgetOfExactType<TermTheme>();
    assert(widget != null, 'No TermTheme found in context');
    return widget!.data;
  }

  @override
  Widget build(BuildContext context) => child;
}

@immutable
class TermThemeData {
  const TermThemeData({required this.color});

  final Color color;
}