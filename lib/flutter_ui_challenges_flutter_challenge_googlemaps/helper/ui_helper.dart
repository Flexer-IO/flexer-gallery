import 'dart:core';

/// ui standard
const double standardWidth = 375.0;
const double standardHeight = 815.0;

/// late init
late double screenWidth;
late double screenHeight;

/// scale [height] by [standardHeight]
double realH(double height) {
  assert(screenHeight != 0.0);
  return height / standardHeight * screenHeight;
}

// scale [width] by [ standardWidth ]
double realW(double width) {
  assert(screenWidth != 0.0);
  return width / standardWidth * screenWidth;
}