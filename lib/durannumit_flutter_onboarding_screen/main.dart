import 'dart:async';

import 'package:flutter/material.dart' hide Page;
import 'Animation_Gesture/page_dragger.dart' as dragger;
import 'Animation_Gesture/page_reveal.dart';
import 'UI/pager_indicator.dart' as indicator;
import 'UI/pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material Page Reveal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin {
  late final StreamController<dragger.SlideUpdate> slideUpdateStream;
  dragger.AnimatedPageDragger? animatedPageDragger;

  int activeIndex = 0;
  dragger.SlideDirection slideDirection = dragger.SlideDirection.none;
  int nextPageIndex = 0;
  double slidePercent = 0.0;

  _MyHomePageState() {
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
        } else if (event.updateType == dragger.UpdateType.doneDragging) {
          if (slidePercent > 0.5) {
            animatedPageDragger = dragger.AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: dragger.TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
          } else {
            animatedPageDragger = dragger.AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: dragger.TransitionGoal.close,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
          }

          animatedPageDragger!.run();
        } else if (event.updateType == dragger.UpdateType.animating) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        } else if (event.updateType == dragger.UpdateType.doneAnimating) {
          if (animatedPageDragger?.transitionGoal == dragger.TransitionGoal.open) {
            activeIndex = nextPageIndex;
          }
          slideDirection = dragger.SlideDirection.none;
          slidePercent = 0.0;

          animatedPageDragger?.dispose();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
              pages,
              activeIndex,
              // Convert to the enum type expected by PagerIndicatorViewModel
              indicator.SlideDirection.values[slideDirection.index],
              slidePercent,
            ),
          ),
          dragger.PageDragger(
            canDragLeftToRight: activeIndex > 0,
            canDragRightToLeft: activeIndex < pages.length - 1,
            slideUpdateStream: slideUpdateStream,
          )
        ],
      ),
    );
  }
}