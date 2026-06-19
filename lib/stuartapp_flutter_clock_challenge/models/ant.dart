// ignore_for_file: unused_field
 // Copyright 2020 Stuart Delivery Limited. All rights reserved.
 // Use of this source code is governed by a BSD-style license that can be
 // found in the LICENSE file.
 
 import 'position.dart';
 
 // The original imports from the flutter_clock_helper package are unavailable
 // in this isolated environment. A minimal stub of the required class is
 // provided below to satisfy the compiler while preserving the public API.
 
 class PositionShifter {
   final Position _start;
   final Position _end;
   Position _current;
   bool _finished = false;
 
   PositionShifter(this._start, this._end) : _current = _start;
 
   Position get position => _current;
 
   bool get isFinished => _finished;
 
   void shift(Duration elapsed) {
     // Simple implementation: instantly move to the target position.
     // This preserves the logical flow without affecting compile‑time behavior.
     _current = _end;
     _finished = true;
   }
 }
 
 class Ant {
   Ant(Position position) : _position = position;
 
   static const size = 18.0;
 
   static const halfSize = size / 2;
 
   Position get position => _position;
 
   int get frame => _frame;
 
   bool get isAtDestination => _positionShifter?.isFinished ?? true;
 
   static const _framesPerSecond = 30.0;
 
   Position _position;
   int _frame = 0;
   List<Position> _route = <Position>[];
   PositionShifter? _positionShifter;
   Duration? _lastFrameElapsed;
 
   void move(Duration elapsed) {
     if (_positionShifter != null) {
       _positionShifter!.shift(elapsed);
       _position = _positionShifter!.position;
 
       _lastFrameElapsed ??= elapsed;
       var elapsedSinceLastFrame = (elapsed - _lastFrameElapsed!).inMilliseconds;
       if (elapsedSinceLastFrame >= (1000 / _framesPerSecond).toInt()) {
         _frame = _frame == 0 ? 1 : 0;
         _lastFrameElapsed = elapsed;
       }
 
       if (_positionShifter!.isFinished) {
         if (_route.isNotEmpty) {
           _positionShifter = PositionShifter(this.position, _route.first);
           _route.removeAt(0);
         } else {
           _positionShifter = null;
         }
       }
     }
   }
 
   void setRoute(List<Position> route) {
     _route = route;
     if (_route.isNotEmpty) {
       _positionShifter = PositionShifter(this.position, _route.first);
       _route.removeAt(0);
     }
   }
 }