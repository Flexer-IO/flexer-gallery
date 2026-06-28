import 'dart:async';

import 'page_dragger.dart' as dragger;
import 'page_indicator.dart' as indicator;
import 'page_reveal.dart';
import 'pages.dart';
import 'package:flutter/material.dart' hide Page;

class PageMain extends StatefulWidget {
  @override
  PageMainState createState() => PageMainState();
}

class PageMainState extends State<PageMain> with TickerProviderStateMixin {
  late final StreamController<dragger.SlideUpdate> slideUpdateStream;
  late dragger.AnimatedPagedragger animatedPagedragger;

  int activeIndex = 0;
  int nextPageIndex = 0;
  dragger.SlideDirection slideDirection = dragger.SlideDirection.none;
  double slidePercent = 0.0;

  @override
  void initState() {
    super.initState();
    slideUpdateStream = StreamController<dragger.SlideUpdate>();

    slideUpdateStream.stream.listen((dragger.SlideUpdate event) {
      setState(() {
        if (event.updateType == dragger.UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if (slideDirection == dragger.SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == dragger.SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }
        } else if (event.updateType == dragger.UpdateType.animating) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        } else if (event.updateType == dragger.UpdateType.doneDragging) {
          if (slidePercent > 0.5) {
            animatedPagedragger = dragger.AnimatedPagedragger(
              slideDirection: slideDirection,
              transitionGoal: dragger.TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
          } else {
            animatedPagedragger = dragger.AnimatedPagedragger(
              slideDirection: slideDirection,
              transitionGoal: dragger.TransitionGoal.close,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
            nextPageIndex = activeIndex;
          }
          animatedPagedragger.run();
        } else if (event.updateType == dragger.UpdateType.doneAnimating) {
          activeIndex = nextPageIndex;
          slideDirection = dragger.SlideDirection.none;
          slidePercent = 0.0;
          animatedPagedragger.dispose();
        }
      });
    });
  }

  @override
  void dispose() {
    slideUpdateStream.close();
    super.dispose();
  }

  // Helper to map dragger.SlideDirection to indicator.SlideDirection
  indicator.SlideDirection _mapSlideDirection(dragger.SlideDirection dir) {
    switch (dir) {
      case dragger.SlideDirection.none:
        return indicator.SlideDirection.none;
      case dragger.SlideDirection.leftToRight:
        return indicator.SlideDirection.leftToRight;
      case dragger.SlideDirection.rightToLeft:
        return indicator.SlideDirection.rightToLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Page(
            viewModel: pages[activeIndex],
            percentVisible: 1.0,
          ),
          PageReveal(
            revealPercent: slidePercent,
            child: Page(
              viewModel: pages[nextPageIndex],
              percentVisible: slidePercent,
            ),
          ),
          indicator.PagerIndicator(
            viewModel: indicator.PagerIndicatorViewModel(
              _mapSlideDirection(slideDirection),
              activeIndex,
              pages,
              slidePercent,
            ),
          ),
          dragger.PageDragger(
            canDragLeftToRight: activeIndex > 0,
            canDragRightToLeft: activeIndex < pages.length - 1,
            slideUpdateSytream: slideUpdateStream,
          ),
        ],
      ),
    );
  }
}