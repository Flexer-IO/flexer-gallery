import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

// -----------------------------------------------------------------------------
// Stub implementations for missing project files (to satisfy compilation)
// -----------------------------------------------------------------------------
/// Represents a series of integer data points with a label.
class DataSeries {
  final List<int> series;
  final String label;

  const DataSeries({
    required this.series,
    required this.label,
  });
}

/// Represents a milestone label associated with a week number.
class WeekLabel {
  final int weekNum;
  final String label;

  const WeekLabel({
    required this.weekNum,
    required this.label,
  });
}

/// Utility class providing mapping functions.
class MathUtils {
  /// Maps [value] from the input range to the output range.
  static double map(double value, double inMin, double inMax, double outMin, double outMax) {
    if (inMax - inMin == 0) return outMin;
    return ((value - inMin) / (inMax - inMin)) * (outMax - outMin) + outMin;
  }

  /// Same as [map] but clamps the input value to the input range first.
  static double clampedMap(double value, double inMin, double inMax, double outMin, double outMax) {
    double v = value;
    if (v < inMin) v = inMin;
    if (v > inMax) v = inMax;
    return map(v, inMin, inMax, outMin, outMax);
  }
}

/// Holds constant colors used by the chart.
class Constants {
  static const Color backgroundColor = Color(0xFF000000);
  static const Color milestoneColor = Color(0xFFFFFFFF);
}

/// Simple 2‑D point used by the Catmull‑Rom interpolator.
class Point2D {
  final double x;
  final double y;

  const Point2D(this.x, this.y);
}

/// Holds a value that can be modified by the interpolator.
class ControlPointAndValue {
  double value = 0.0;
  ControlPointAndValue();
}

/// Minimal Catmull‑Rom interpolator stub.
class CatmullInterpolator {
  final List<Point2D> controlPoints;

  CatmullInterpolator(this.controlPoints);

  /// In the real implementation this would modify [cpv.value] based on the
  /// Catmull‑Rom spline. For the stub we simply leave the value unchanged.
  void progressiveGet(ControlPointAndValue cpv) {
    // No‑op stub – the caller already set cpv.value.
  }
}

// -----------------------------------------------------------------------------
// Original widget implementation (unchanged UI logic)
// -----------------------------------------------------------------------------

/// A widget that draws a series of filled charts layered next to, or on top of each other.
/// The widget will adjust it's draw angle based on screen size ratio to better handle landscape and
/// portrait orientations.
class LayeredChart extends StatefulWidget {
  final List<DataSeries> dataToPlot;
  final List<WeekLabel> milestones;
  final double animationValue;

  const LayeredChart(this.dataToPlot, this.milestones, this.animationValue, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LayeredChartState();
  }
}

class DrawCache {
  late List<Path> paths;
  late List<Path> capPaths;
  late List<double> maxValues;
  late double theta;
  late double graphHeight;
  late List<TextPainter> labelPainter;
  late List<TextPainter> milestonePainter;
  Size? lastSize;

  void buildCache(
      Size size,
      List<DataSeries> dataToPlot,
      List<WeekLabel> milestones,
      int numPoints,
      double graphGap,
      double margin,
      double capTheta,
      double capSize) {
    double screenRatio = size.width / size.height;
    double degrees = MathUtils.clampedMap(screenRatio, 0.5, 2.5, 50, 5);
    theta = pi * degrees / 180;
    graphHeight = MathUtils.clampedMap(screenRatio, 0.5, 2.5, 50, 150);

    int m = dataToPlot.length;
    paths = List<Path>.generate(m, (_) => Path());
    capPaths = List<Path>.generate(m, (_) => Path());
    maxValues = List<double>.filled(m, 0.0, growable: false);
    for (int i = 0; i < m; i++) {
      int n = dataToPlot[i].series.length;
      maxValues[i] = 0;
      for (int j = 0; j < n; j++) {
        double v = dataToPlot[i].series[j].toDouble();
        if (v > maxValues[i]) {
          maxValues[i] = v;
        }
      }
    }
    double totalGap = m * graphGap;
    double xIndent = totalGap / tan(capTheta);
    double startX = margin + xIndent;
    double endX = size.width - margin;
    double startY = size.height;
    double endY = startY - (endX - startX) * tan(theta);
    double xWidth = (endX - startX) / numPoints;
    double capRangeX = capSize * cos(capTheta);
    double tanCapTheta = tan(capTheta);
    List<double> curvePoints = List<double>.filled(numPoints, 0.0, growable: false);
    for (int i = 0; i < m; i++) {
      List<int> series = dataToPlot[i].series;
      int n = series.length;
      List<Point2D> controlPoints = [];
      controlPoints.add(const Point2D(-1, 0));
      double last = 0;
      for (int j = 0; j < n; j++) {
        double v = series[j].toDouble();
        controlPoints.add(Point2D(j.toDouble(), v));
        last = v;
      }
      controlPoints.add(Point2D(n.toDouble(), last));
      CatmullInterpolator curve = CatmullInterpolator(controlPoints);
      ControlPointAndValue cpv = ControlPointAndValue();
      for (int j = 0; j < numPoints; j++) {
        cpv.value = MathUtils.map(j.toDouble(), 0, (numPoints - 1).toDouble(), 0, (n - 1).toDouble());
        curve.progressiveGet(cpv);
        curvePoints[j] = MathUtils.map(max(0, cpv.value), 0, maxValues[i].toDouble(), 0, graphHeight);
      }
      paths[i] = Path();
      capPaths[i] = Path();
      paths[i].moveTo(startX, startY);
      capPaths[i].moveTo(startX, startY);
      for (int j = 0; j < numPoints; j++) {
        double v = curvePoints[j];
        int k = j + 1;
        double xDist = xWidth;
        double capV = v;
        while (k < numPoints && xDist <= capRangeX) {
          double cy = curvePoints[k] + xDist * tanCapTheta;
          capV = max(capV, cy);
          k++;
          xDist += xWidth;
        }
        double x = MathUtils.map(j.toDouble(), 0, (numPoints - 1).toDouble(), startX, endX);
        double baseY = MathUtils.map(j.toDouble(), 0, (numPoints - 1).toDouble(), startY, endY);
        double y = baseY - v;
        double cY = baseY - capV;
        paths[i].lineTo(x, y);
        if (j == 0) {
          int k = capRangeX ~/ xWidth;
          double mx = MathUtils.map(-k.toDouble(), 0, (numPoints - 1).toDouble(), startX, endX);
          double my = MathUtils.map(-k.toDouble(), 0, (numPoints - 1).toDouble(), startY, endY) - capV;
          capPaths[i].lineTo(mx, my);
        }
        capPaths[i].lineTo(x, cY);
      }
      paths[i].lineTo(endX, endY);
      paths[i].lineTo(endX, endY + 1);
      paths[i].lineTo(startX, startY + 1);
      paths[i].close();
      capPaths[i].lineTo(endX, endY);
      capPaths[i].lineTo(endX, endY + 1);
      capPaths[i].lineTo(startX, startY + 1);
      capPaths[i].close();
    }
    labelPainter = [];
    for (int i = 0; i < dataToPlot.length; i++) {
      TextSpan span = TextSpan(
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 12),
          text: dataToPlot[i].label.toUpperCase());
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      labelPainter.add(tp);
    }
    milestonePainter = [];
    for (int i = 0; i < milestones.length; i++) {
      TextSpan span = TextSpan(
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 10),
          text: milestones[i].label.toUpperCase());
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      milestonePainter.add(tp);
    }
    lastSize = Size(size.width, size.height);
  }
}

class LayeredChartState extends State<LayeredChart> {
  final DrawCache drawCache = DrawCache();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Constants.backgroundColor,
        child: CustomPaint(
            foregroundPainter: ChartPainter(
                drawCache: drawCache,
                dataToPlot: widget.dataToPlot,
                milestones: widget.milestones,
                animationValue: widget.animationValue),
            child: Container()));
  }
}

class ChartPainter extends CustomPainter {
  static final List<Color> colors = [
    Colors.red.shade900,
    const Color(0xffc4721a),
    Colors.lime.shade900,
    Colors.green.shade900,
    Colors.blue.shade900,
    Colors.purple.shade900,
  ];
  static final List<Color> capColors = [
    Colors.red.shade500,
    Colors.amber.shade500,
    Colors.lime.shade500,
    Colors.green.shade500,
    Colors.blue.shade500,
    Colors.purple.shade500,
  ];

  final List<DataSeries> dataToPlot;
  final List<WeekLabel> milestones;

  final double margin;
  final double graphGap;
  final double capTheta;
  final double capSize;
  final int numPoints;
  final double animationValue;

  late final Paint pathPaint;
  late final Paint capPaint;
  late final Paint textPaint;
  late final Paint milestonePaint;
  late final Paint linePaint;
  late final Paint fillPaint;

  final DrawCache drawCache;

  ChartPainter({
    required this.drawCache,
    required this.dataToPlot,
    required this.milestones,
    this.margin = 80,
    this.graphGap = 50,
    double capDegrees = 50,
    this.capSize = 12,
    this.numPoints = 500,
    required this.animationValue,
  }) : capTheta = pi * capDegrees / 180 {
    pathPaint = Paint()..style = PaintingStyle.fill;
    capPaint = Paint()..style = PaintingStyle.fill;
    textPaint = Paint()..color = const Color(0xFFFFFFFF);
    milestonePaint = Paint()
      ..color = Constants.milestoneColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF000000);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (dataToPlot.isEmpty) {
      return;
    }

    if (drawCache.lastSize == null ||
        size.width != drawCache.lastSize!.width ||
        size.height != drawCache.lastSize!.height) {
      // ignore: avoid_print
      print("Building paths, lastsize = ${drawCache.lastSize}");
      drawCache.buildCache(
          size, dataToPlot, milestones, numPoints, graphGap, margin, capTheta, capSize);
    }

    int m = dataToPlot.length;
    int numWeeks = dataToPlot[0].series.length;
    // How far along to draw
    double totalGap = m * graphGap;
    double xIndent = totalGap / tan(capTheta);
    double dx = xIndent / (m - 1);
    double startX = margin + xIndent;
    double endX = size.width - margin;
    double startY = size.height;
    double endY = startY - (endX - startX) * tan(drawCache.theta);
    // MILESTONES
    {
      for (int i = 0; i < milestones.length; i++) {
        WeekLabel milestone = milestones[i];
        double p = (milestone.weekNum.toDouble() / numWeeks) + (1 - animationValue);
        if (p < 1) {
          double x1 = MathUtils.map(p, 0, 1, startX, endX);
          double y1 = MathUtils.map(p, 0, 1, startY, endY);
          double x2 = x1 - xIndent;
          double y2 = y1 - graphGap * (m - 1);
          x1 += dx * 0.5;
          y1 += graphGap * 0.5;
          double textY = y1 + 5;
          double textX = x1 + 5 * tan(capTheta);
          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), milestonePaint);
          canvas.save();
          TextPainter tp = drawCache.milestonePainter[i];
          canvas.translate(textX, textY);
          canvas.skew(tan(capTheta * 1.0), -tan(drawCache.theta));
          canvas.translate(-tp.width / 2, 0);
          tp.paint(canvas, Offset.zero);
          canvas.restore();
        }
      }
    }
    for (int i = m - 1; i >= 0; i--) {
      canvas.save();
      canvas.translate(-dx * i, -graphGap * i);

      {
        // TEXT LABELS
        canvas.save();
        double textPosition = 0.2;
        double textX = MathUtils.map(textPosition, 0, 1, startX, endX);
        double textY = MathUtils.map(textPosition, 0, 1, startY, endY) + 5;
        canvas.translate(textX, textY);
        TextPainter tp = drawCache.labelPainter[i];
        canvas.skew(0, -tan(drawCache.theta));
        canvas.drawRect(Rect.fromLTWH(-1, -1, tp.width + 2, tp.height + 2), fillPaint);
        tp.paint(canvas, Offset.zero);
        canvas.restore();
      }

      linePaint.color = capColors[i];
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), linePaint);

      Path clipPath = Path()
        ..moveTo(startX - capSize, startY + 11)
        ..lineTo(endX, endY + 1)
        ..lineTo(endX, endY - drawCache.graphHeight - capSize)
        ..lineTo(startX - capSize, startY - drawCache.graphHeight - capSize)
        ..close();
      canvas.clipPath(clipPath);

      pathPaint.color = colors[i];
      capPaint.color = capColors[i];
      double offsetX = MathUtils.map(1 - animationValue, 0, 1, startX, endX);
      double offsetY = MathUtils.map(1 - animationValue, 0, 1, startY, endY);
      canvas.translate(offsetX - startX, offsetY - startY);
      canvas.drawPath(drawCache.capPaths[i], capPaint);
      canvas.drawPath(drawCache.paths[i], pathPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}