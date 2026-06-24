library foo;

import 'package:flutter/widgets.dart';

/// I-wrap ang iyong root App widget sa widget na ito at tawagin ang [Foo.restart] para i-restart ang iyong app.
class Foo extends StatefulWidget {
  final Widget app;

  Foo({this.app});

  @override
  _FooState createState() => _FooState();

  static restart(BuildContext context) {
    context.findAncestorStateOfType<_FooState>().restartApp();
  }
}

class _FooState extends State<Foo> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.app,
    );
  }
}