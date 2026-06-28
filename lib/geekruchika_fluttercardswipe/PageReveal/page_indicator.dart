import 'dart:ui';

import 'pages.dart';
import 'package:flutter/material.dart';

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel viewModel;

  const PagerIndicator({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbles = [];

    for (var i = 0; i < viewModel.pages.length; ++i) {
      final page = viewModel.pages[i];
      double percentActive;
      if (i == viewModel.activeIndex) {
        percentActive = 1.0 - viewModel.slidePercent;
      } else if (i == viewModel.activeIndex - 1 &&
          viewModel.slideDirection == SlideDirection.leftToRight) {
        percentActive = viewModel.slidePercent;
      } else if (i == viewModel.activeIndex + 1 &&
          viewModel.slideDirection == SlideDirection.rightToLeft) {
        percentActive = viewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      bool isHollow = i > viewModel.activeIndex ||
          (i == viewModel.activeIndex &&
              viewModel.slideDirection == SlideDirection.leftToRight);

      bubbles.add(PageBubble(
        viewModel: PageBubbleViewModel(
            page.color, percentActive, page.iconAssetIcon, isHollow),
      ));
    }

    const double BUBBLE_WIDTH = 55.0;
    final double baseTranslation =
        ((viewModel.pages.length * BUBBLE_WIDTH) / 2) - (BUBBLE_WIDTH / 2);
    double translation = baseTranslation - (viewModel.activeIndex * BUBBLE_WIDTH);

    if (viewModel.slideDirection == SlideDirection.leftToRight) {
      translation += BUBBLE_WIDTH * viewModel.slidePercent;
    } else if (viewModel.slideDirection == SlideDirection.rightToLeft) {
      translation -= BUBBLE_WIDTH * viewModel.slidePercent;
    }

    return Column(
      children: <Widget>[
        const Expanded(child: SizedBox()),
        Transform(
          transform: Matrix4.translationValues(translation, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbles,
          ),
        ),
      ],
    );
  }
}

enum SlideDirection { leftToRight, rightToLeft, none }

class PagerIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicatorViewModel(
      this.slideDirection, this.activeIndex, this.pages, this.slidePercent);
}

class PageBubble extends StatelessWidget {
  final PageBubbleViewModel viewModel;

  const PageBubble({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.0,
      height: 65.0,
      child: Center(
        child: Container(
          width: lerpDouble(25.0, 45.0, viewModel.activePercent),
          height: lerpDouble(25.0, 45.0, viewModel.activePercent),
          decoration: BoxDecoration(
              color: viewModel.isHollow
                  ? const Color(0x88FFFFFF)
                      .withAlpha((0x88 * viewModel.activePercent).round())
                  : const Color(0x88FFFFFF),
              shape: BoxShape.circle,
              border: Border.all(
                  color: viewModel.isHollow
                      ? const Color(0x88FFFFFF).withAlpha(
                          (0x88 * (1.0 - viewModel.activePercent)).round())
                      : Colors.transparent)),
          child: Opacity(
              opacity: viewModel.activePercent,
              child: Icon(
                viewModel.iconPath,
                color: viewModel.color,
              )),
        ),
      ),
    );
  }
}

class PageBubbleViewModel {
  final IconData iconPath;
  final Color color;
  final bool isHollow;
  final double activePercent;

  PageBubbleViewModel(
      this.color, this.activePercent, this.iconPath, this.isHollow);
}