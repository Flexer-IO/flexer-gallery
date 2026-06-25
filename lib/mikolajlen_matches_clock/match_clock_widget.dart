import 'dart:async';

import 'package:flutter/material.dart';
import 'match.dart';

// Stub definition for MatchesCreator to resolve missing import.
// In the original project this would be provided by a separate file.
abstract class MatchesCreator {
  // Returns an iterable of matches for the first digit of the hour.
  Iterable<Match> getFirstDigitMatches(Iterable<Match> matches);
  // Returns an iterable of matches for the second digit of the hour.
  Iterable<Match> getSecondDigitMatches(Iterable<Match> matches);
  // Returns an iterable of matches for the first digit of the minute.
  Iterable<Match> getThirdDigitMatches(Iterable<Match> matches);
  // Returns an iterable of matches for the second digit of the minute.
  Iterable<Match> getFourthDigitMatches(Iterable<Match> matches);
  // Returns an iterable of matches representing a digit (0‑9).
  Iterable<Match> getMatchesForDigit(int digit);

  // Layout parameters.
  double get bottom;
  double get center;
  double get matchHeight;
  double get matchWidth;

  // Builds a widget for a single match.
  Widget buildMatchImage(Match match);
  // Builds the divider widget displayed between the two halves of the clock.
  Widget buildDivider();
}

class MatchClockWidget extends StatefulWidget {
  const MatchClockWidget({Key? key, required this.creator}) : super(key: key);

  final MatchesCreator creator;

  @override
  _MatchClockWidgetState createState() => _MatchClockWidgetState();
}

class _MatchClockWidgetState extends State<MatchClockWidget>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late List<Match> _matches;
  List<Match>? _matchesToStay;
  List<Match>? _beforeAnimation;
  List<Match>? _afterAnimation;
  List<Match>? _desiredMatches;
  Timer? _timer;
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    final hour = _dateTime.hour;
    final minute = _dateTime.minute;
    _matches = [
      ...widget.creator
          .getFirstDigitMatches(widget.creator.getMatchesForDigit(hour ~/ 10))
          .toList(),
      ...widget.creator
          .getSecondDigitMatches(widget.creator.getMatchesForDigit(hour % 10))
          .toList(),
      ...widget.creator
          .getThirdDigitMatches(widget.creator.getMatchesForDigit(minute ~/ 10))
          .toList(),
      ...widget.creator
          .getFourthDigitMatches(widget.creator.getMatchesForDigit(minute % 10))
          .toList(),
    ];
    _initTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initTime() {
    _dateTime = DateTime.now();
    _timer = Timer(
      const Duration(minutes: 1) -
          Duration(seconds: _dateTime.second) -
          Duration(milliseconds: _dateTime.millisecond),
      _updateTime,
    );
  }

  void _updateTime() {
    _dateTime = DateTime.now();
    final hour = _dateTime.hour;
    final minute = _dateTime.minute;
    calculateMatches([
      ...widget.creator
          .getFirstDigitMatches(widget.creator.getMatchesForDigit(hour ~/ 10))
          .toList(),
      ...widget.creator
          .getSecondDigitMatches(widget.creator.getMatchesForDigit(hour % 10))
          .toList(),
      ...widget.creator
          .getThirdDigitMatches(widget.creator.getMatchesForDigit(minute ~/ 10))
          .toList(),
      ...widget.creator
          .getFourthDigitMatches(widget.creator.getMatchesForDigit(minute % 10))
          .toList(),
    ]);
    _timer = Timer(
      const Duration(minutes: 1) -
          Duration(seconds: _dateTime.second) -
          Duration(milliseconds: _dateTime.millisecond),
      _updateTime,
    );
  }

  void calculateMatches(List<Match> matchesToUpdate) {
    final matchesToStay =
        _matches.where((match) => matchesToUpdate.contains(match)).toList();
    final beforeAnimation = _matches
        .where((match) => !matchesToStay.contains(match))
        .toList(growable: true);
    final afterAnimation = matchesToUpdate
        .where((match) => !matchesToStay.contains(match))
        .toList(growable: true);
    if (beforeAnimation.length > afterAnimation.length) {
      for (var i = afterAnimation.length; i < beforeAnimation.length; i++) {
        afterAnimation.add(Match(
            paddingTop: widget.creator.bottom,
            paddingLeft: widget.creator.center));
      }
    } else if (afterAnimation.length > beforeAnimation.length) {
      for (var i = beforeAnimation.length; i < afterAnimation.length; i++) {
        beforeAnimation.add(Match(
            paddingTop: widget.creator.matchHeight * -1,
            paddingLeft: widget.creator.center));
      }
    }

    _matchesToStay = matchesToStay;
    _beforeAnimation = beforeAnimation;
    _afterAnimation = afterAnimation;
    _desiredMatches = matchesToUpdate;
    controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    animation = Tween<double>(begin: 0, end: 100).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          setState(() {
            _matches = _desiredMatches!;
            _beforeAnimation = null;
            _afterAnimation = null;
            _desiredMatches = null;
          });
        }
      })
      ..addListener(() {
        setState(() {
          _matches = [..._matchesToStay!];
          for (var i = 0; i < beforeAnimation.length; i++) {
            final xDiff = (_afterAnimation![i].paddingLeft -
                    _beforeAnimation![i].paddingLeft) /
                100.0;
            double yDiff;
            if (_afterAnimation![i].rotation == 0 &&
                beforeAnimation[i].rotation != 0) {
              yDiff = (_afterAnimation![i].paddingTop -
                      _beforeAnimation![i].paddingTop -
                      widget.creator.matchWidth) /
                  100.0;
            } else {
              yDiff = (_afterAnimation![i].paddingTop -
                      _beforeAnimation![i].paddingTop) /
                  100.0;
            }
            final radiansDiff =
                (_afterAnimation![i].rotation - _beforeAnimation![i].rotation) /
                    100.0;
            final x =
                beforeAnimation[i].paddingLeft + (xDiff * animation.value);
            final y = beforeAnimation[i].paddingTop + (yDiff * animation.value);
            final radians = beforeAnimation[i].rotation +
                (radiansDiff * animation.value);
            _matches
                .add(Match(paddingLeft: x, paddingTop: y, rotation: radians));
          }
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          ..._matches
              .map((match) => widget.creator.buildMatchImage(match))
              .toList(),
          widget.creator.buildDivider()
        ],
      );
}