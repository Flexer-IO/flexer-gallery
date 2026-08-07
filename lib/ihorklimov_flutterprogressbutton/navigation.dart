import 'deps/fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'page_two.dart';
import 'home_page.dart';

class Navigation {
  static late final FluroRouter router;

  static void initPaths() {
    router = FluroRouter()
      ..define(
        '/',
        handler: Handler(
          handlerFunc: (BuildContext? context,
              Map<String, List<String>>? params) {
            return MyHomePage(title: 'Progress Button');
          },
        ),
      )
      ..define(
        'page_two',
        handler: Handler(
          handlerFunc: (BuildContext? context,
              Map<String, List<String>>? params) {
            return PageTwo(title: 'Second Page');
          },
        ),
      );
  }

  static void navigateTo(
    BuildContext context,
    String path, {
    bool replace = false,
    TransitionType transition = TransitionType.native,
    Duration transitionDuration = const Duration(milliseconds: 250),
    RouteTransitionsBuilder? transitionBuilder,
  }) {
    router.navigateTo(
      context,
      path,
      replace: replace,
      transition: transition,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
    );
  }
}