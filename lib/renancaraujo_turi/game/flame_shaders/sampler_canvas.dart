import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';

abstract class SamplerOwner {
  SamplerOwner(this.shader, {this.passes = 1});

  final FragmentShader shader;

  final int passes;

  CameraComponent? cameraComponent;

  // ignore: use_setters_to_change_properties
  void attachCamera(CameraComponent cameraComponent) {
    this.cameraComponent = cameraComponent;
  }

  void update(double dt) {}

  void sampler(List<Image> images, Size size, Canvas canvas);
}

class SamplerCanvas<O extends SamplerOwner> implements Canvas {
  SamplerCanvas({
    required this.actualCanvas,
    required this.owner,
    required this.pass,
  });

  final Canvas actualCanvas;
  final O owner;
  final int pass;

  @override
  void clipPath(Path path, {bool doAntiAlias = true}) {
    actualCanvas.clipPath(path, doAntiAlias: doAntiAlias);
  }

  @override
  void clipRRect(RRect rrect, {bool doAntiAlias = true}) {
    actualCanvas.clipRRect(rrect, doAntiAlias: doAntiAlias);
  }

  @override
  void clipRect(
    Rect rect, {
    ClipOp clipOp = ClipOp.intersect,
    bool doAntiAlias = true,
  }) {
    actualCanvas.clipRect(
      rect,
      clipOp: clipOp,
      doAntiAlias: doAntiAlias,
    );
  }

  @override
  void clipRSuperellipse(RSuperellipse superellipse, {bool doAntiAlias = true}) {
    actualCanvas.clipRSuperellipse(superellipse, doAntiAlias: doAntiAlias);
  }

  @override
  void drawArc(
    Rect rect,
    double startAngle,
    double sweepAngle,
    bool useCenter,
    Paint paint,
  ) {
    actualCanvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      useCenter,
      paint,
    );
  }

  @override
  void drawAtlas(
    Image atlas,
    List<RSTransform> transforms,
    List<Rect> rects,
    List<Color>? colors,
    BlendMode? blendMode,
    Rect? cullRect,
    Paint paint,
  ) {
    actualCanvas.drawAtlas(
      atlas,
      transforms,
      rects,
      colors,
      blendMode,
      cullRect,
      paint,
    );
  }

  @override
  void drawCircle(Offset c, double radius, Paint paint) {
    actualCanvas.drawCircle(c, radius, paint);
  }

  @override
  void drawColor(Color color, BlendMode blendMode) {
    actualCanvas.drawColor(color, blendMode);
  }

  @override
  void drawDRRect(RRect outer, RRect inner, Paint paint) {
    actualCanvas.drawDRRect(outer, inner, paint);
  }

  @override
  void drawImage(Image image, Offset offset, Paint paint) {
    actualCanvas.drawImage(image, offset, paint);
  }

  @override
  void drawImageNine(Image image, Rect center, Rect dst, Paint paint) {
    actualCanvas.drawImageNine(image, center, dst, paint);
  }

  @override
  void drawImageRect(Image image, Rect src, Rect dst, Paint paint) {
    actualCanvas.drawImageRect(image, src, dst, paint);
  }

  @override
  void drawLine(Offset p1, Offset p2, Paint paint) {
    actualCanvas.drawLine(p1, p2, paint);
  }

  @override
  void drawOval(Rect rect, Paint paint) {
    actualCanvas.drawOval(rect, paint);
  }

  @override
  void drawPaint(Paint paint) {
    actualCanvas.drawPaint(paint);
  }

  @override
  void drawParagraph(Paragraph paragraph, Offset offset) {
    actualCanvas.drawParagraph(paragraph, offset);
  }

  @override
  void drawPath(Path path, Paint paint) {
    actualCanvas.drawPath(path, paint);
  }

  @override
  void drawPicture(Picture picture) {
    actualCanvas.drawPicture(picture);
  }

  @override
  void drawPoints(PointMode pointMode, List<Offset> points, Paint paint) {
    actualCanvas.drawPoints(pointMode, points, paint);
  }

  @override
  void drawRRect(RRect rrect, Paint paint) {
    actualCanvas.drawRRect(rrect, paint);
  }

  @override
  void drawRSuperellipse(RSuperellipse superellipse, Paint paint) {
    actualCanvas.drawRSuperellipse(superellipse, paint);
  }

  @override
  void drawRawAtlas(
    Image atlas,
    Float32List rstTransforms,
    Float32List rects,
    Int32List? colors,
    BlendMode? blendMode,
    Rect? cullRect,
    Paint paint,
  ) {
    actualCanvas.drawRawAtlas(
      atlas,
      rstTransforms,
      rects,
      colors,
      blendMode,
      cullRect,
      paint,
    );
  }

  @override
  void drawRawPoints(PointMode pointMode, Float32List points, Paint paint) {
    actualCanvas.drawRawPoints(pointMode, points, paint);
  }

  @override
  void drawRect(Rect rect, Paint paint) {
    actualCanvas.drawRect(rect, paint);
  }

  @override
  void drawShadow(
    Path path,
    Color color,
    double elevation,
    bool transparentOccluder,
  ) {
    actualCanvas.drawShadow(
      path,
      color,
      elevation,
      transparentOccluder,
    );
  }

  @override
  void drawVertices(Vertices vertices, BlendMode blendMode, Paint paint) {
    actualCanvas.drawVertices(vertices, blendMode, paint);
  }

  @override
  Rect getDestinationClipBounds() {
    return actualCanvas.getDestinationClipBounds();
  }

  @override
  Rect getLocalClipBounds() {
    return actualCanvas.getLocalClipBounds();
  }

  @override
  int getSaveCount() {
    return actualCanvas.getSaveCount();
  }

  @override
  Float64List getTransform() {
    return actualCanvas.getTransform();
  }

  @override
  void restore() {
    actualCanvas.restore();
  }

  @override
  void restoreToCount(int count) {
    actualCanvas.restoreToCount(count);
  }

  @override
  void rotate(double radians) {
    actualCanvas.rotate(radians);
  }

  @override
  void save() {
    actualCanvas.save();
  }

  @override
  void saveLayer(Rect? bounds, Paint paint) {
    actualCanvas.saveLayer(bounds, paint);
  }

  @override
  void scale(double sx, [double? sy]) {
    actualCanvas.scale(sx, sy);
  }

  @override
  void skew(double sx, double sy) {
    actualCanvas.skew(sx, sy);
  }

  @override
  void transform(Float64List matrix4) {
    actualCanvas.transform(matrix4);
  }

  @override
  void translate(double dx, double dy) {
    actualCanvas.translate(dx, dy);
  }
}