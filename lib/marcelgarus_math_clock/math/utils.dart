/// Utility functions that are used in this folder.

import 'dart:math' as math;

T chooseRandomOf<T>(List<T> items) =>
    items[math.Random().nextInt(items.length)];

int squared(int number) => number * number;
int cubed(int number) => number * number * number;
int sqrt(int number) => math.sqrt(number).round();
int factorial(int number) => number < 2 ? 1 : number * factorial(number - 1);