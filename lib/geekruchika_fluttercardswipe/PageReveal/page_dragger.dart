import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class PageDragger extends StatefulWidget {
  final bool canDragRightToLeft;
  final bool canDragLeftToRight;
  final StreamController<SlideUpdate> slideUpdateSytream;

  const PageDragger({
    Key? key,
    required this.canDragLeftToRight,
    required this.canDragRightToLeft,
    required this.slideUpdateSytream,
  }) : super(key: key);

  @override
  _PageDraggerState createState() => _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const FULL_TRANSITION_PX = 300.0;

  Offset? dragStart;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  void onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  void onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart!.dx - newPosition.dx;
      if (dx > 0.0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }

      widget.slideUpdateSytream.add(
        SlideUpdate(UpdateType.dragging, slidePercent, slideDirection),
      );
    }
  }

  void onDragEnd(DragEndDetails details) {
    widget.slideUpdateSytream.add(
      SlideUpdate(UpdateType.doneDragging, 0.0, SlideDirection.none),
    );

    dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }
}

class AnimatedPagedragger {
  static const PERCENT_PER_MILLISECOND = 0.005;

  final SlideDirection slideDirection;
  final TransitionGoal transitionGoal;

  late final AnimationController completionAnimationController;

  AnimatedPagedragger({
    required this.slideDirection,
    required this.transitionGoal,
    required double slidePercent,
    required StreamController<SlideUpdate> slideUpdateStream,
    required TickerProvider vsync,
  }) {
    final double startSlidePercent = slidePercent;
    late double endSlidePercent;
    late Duration duration;

    if (transitionGoal == TransitionGoal.open) {
      endSlidePercent = 1.0;

      final slideRemaining = 1.0 - slidePercent;
      duration = Duration(
        milliseconds:
            (slideRemaining / PERCENT_PER_MILLISECOND).round(),
      );
    } else {
      endSlidePercent = 0.0;
      duration = Duration(
        milliseconds: (slidePercent / PERCENT_PER_MILLISECOND).round(),
      );
    }

    completionAnimationController =
        AnimationController(vsync: vsync, duration: duration)
          ..addListener(() {
            final double slidePercent = lerpDouble(
                startSlidePercent,
                endSlidePercent,
                completionAnimationController.value)!;
            slideUpdateStream.add(
              SlideUpdate(UpdateType.animating, slidePercent, slideDirection),
            );
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              slideUpdateStream.add(
                SlideUpdate(UpdateType.doneAnimating, endSlidePercent, slideDirection),
              );
            }
          });
  }

  void run() {
    completionAnimationController.forward(from: 0.0);
  }

  void dispose() {
    completionAnimationController.dispose();
  }
}

enum TransitionGoal {
  open,
  close,
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

class SlideUpdate {
  final UpdateType updateType;
  final SlideDirection direction;
  final double slidePercent;

  SlideUpdate(this.updateType, this.slidePercent, this.direction);
}