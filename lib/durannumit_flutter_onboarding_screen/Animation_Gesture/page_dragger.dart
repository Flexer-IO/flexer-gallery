import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

// The original import referenced a non‑existent file that defined SlideDirection.
// To keep the visual behavior unchanged we define the enum locally.
enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class PageDragger extends StatefulWidget {
  final bool canDragLeftToRight;
  final bool canDragRightToLeft;
  final StreamController<SlideUpdate> slideUpdateStream;

  const PageDragger({
    Key? key,
    required this.canDragLeftToRight,
    required this.canDragRightToLeft,
    required this.slideUpdateStream,
  }) : super(key: key);

  @override
  _PageDraggerState createState() => _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const FULL_TRANSTITION_PX = 300.0;

  Offset? dragStart;
  SlideDirection? slideDirection;
  double slidePercent = 0.0;

  void onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  void onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart!.dx - newPosition.dx;

      if (dx > 0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / FULL_TRANSTITION_PX).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }

      widget.slideUpdateStream.add(
        SlideUpdate(
          UpdateType.dragging,
          slideDirection!,
          slidePercent,
        ),
      );
    }
  }

  void onDragEnd(DragEndDetails details) {
    widget.slideUpdateStream.add(
      SlideUpdate(
        UpdateType.doneDragging,
        SlideDirection.none,
        0.0,
      ),
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

class AnimatedPageDragger {
  static const PERCENT_PER_MILLISECOND = 0.005;

  final SlideDirection slideDirection;
  final TransitionGoal transitionGoal;

  late final AnimationController completionAnimationController;

  AnimatedPageDragger({
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
        milliseconds:
            (slidePercent / PERCENT_PER_MILLISECOND).round(),
      );
    }

    completionAnimationController = AnimationController(
      duration: duration,
      vsync: vsync,
    )
      ..addListener(() {
        final double currentSlidePercent = lerpDouble(
          startSlidePercent,
          endSlidePercent,
          completionAnimationController.value,
        )!;

        slideUpdateStream.add(
          SlideUpdate(
            UpdateType.animating,
            slideDirection,
            currentSlidePercent,
          ),
        );
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          slideUpdateStream.add(
            SlideUpdate(
              UpdateType.doneAnimating,
              slideDirection,
              endSlidePercent,
            ),
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

  SlideUpdate(
    this.updateType,
    this.direction,
    this.slidePercent,
  );
}