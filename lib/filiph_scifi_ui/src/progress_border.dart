import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ProgressBorder extends Decoration {
  /// The color to fill in the background of the box.
  final Color color;

  final Color? backgroundColor;

  final BoxShape shape = BoxShape.rectangle;

  /// A value from `0.0` to `1.0` that defines how far along the border
  /// animation is.
  final double progress;

  final EdgeInsetsGeometry? _padding;

  /// Creates a box decoration.
  ///
  /// * [color] must not be null.
  /// * If [backgroundColor] is null, this decoration does not paint a
  ///   background color.
  /// * [progress] must not be null.
  const ProgressBorder({
    required this.color,
    this.backgroundColor,
    required this.progress,
    EdgeInsetsGeometry? padding,
  })  : _padding = padding,
        assert(progress >= 0.0 && progress <= 1.0);

  @override
  EdgeInsetsGeometry get padding => _padding ?? EdgeInsets.zero;

  @override
  int get hashCode {
    return Object.hash(
      color,
      backgroundColor,
      progress,
      _padding,
      shape,
    );
  }

  @override
  bool get isComplex => false;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final ProgressBorder typedOther = other as ProgressBorder;
    return color == typedOther.color &&
        backgroundColor == typedOther.backgroundColor &&
        progress == typedOther.progress &&
        _padding == typedOther._padding &&
        shape == typedOther.shape;
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _ProgressBorderPainter(this, onChanged);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..defaultDiagnosticsTreeStyle = DiagnosticsTreeStyle.whitespace
      ..emptyBodyDescription = '<no decorations specified>';

    properties
        .add(DiagnosticsProperty<Color>('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty<Color>(
        'backgroundColor', backgroundColor,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<double>('progress', progress, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', _padding,
        defaultValue: null));
    properties.add(EnumProperty<BoxShape>('shape', shape,
        defaultValue: BoxShape.rectangle));
  }

  @override
  bool hitTest(Size size, Offset position, {TextDirection? textDirection}) {
    // Since this decoration takes the whole box, hit test always succeeds.
    return true;
  }

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a == null) return scale(t);
    if (a is ProgressBorder) return ProgressBorder.lerp(a, this, t);
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b == null) return scale(1.0 - t);
    if (b is ProgressBorder) return ProgressBorder.lerp(this, b, t);
    return super.lerpTo(b, t);
  }

  /// Returns a new box decoration that is scaled by the given factor.
  ProgressBorder scale(double factor) {
    return ProgressBorder(
      color: Color.lerp(color, color, factor) ?? color,
      backgroundColor: backgroundColor != null
          ? (Color.lerp(backgroundColor, backgroundColor, factor) ??
              backgroundColor)
          : null,
      progress: progress,
      padding: _padding,
    );
  }

  /// Linearly interpolate between two box decorations.
  static ProgressBorder? lerp(ProgressBorder? a, ProgressBorder? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b?.scale(t);
    if (b == null) return a.scale(1.0 - t);
    if (t == 0.0) return a;
    if (t == 1.0) return b;
    return ProgressBorder(
      color: Color.lerp(a.color, b.color, t)!,
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      progress: lerpDouble(a.progress, b.progress, t)!,
      padding: a._padding,
    );
  }
}

/// An object that paints a [ProgressBorder] into a canvas.
class _ProgressBorderPainter extends BoxPainter {
  static const int defaultLineWidth = 2;

  final ProgressBorder _decoration;

  final Paint _foregroundPaint;

  _ProgressBorderPainter(this._decoration, VoidCallback? onChanged)
      : _foregroundPaint = Paint()
          ..color = _decoration.color
          ..style = PaintingStyle.fill,
        super(onChanged);

  /// Paint the box decoration into the given location on the given canvas
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    _paintBox(canvas, rect, textDirection);
  }

  void _paintBox(Canvas canvas, Rect rect, TextDirection textDirection) {
    assert(_decoration.progress >= 0.0 && _decoration.progress <= 1.0);
    if (_decoration.progress == 0.0) return;
    final translateToFillWidth = defaultLineWidth - 1.0;
    _drawLineProgress(
        rect.topLeft,
        rect.topRight.translate(0.0, translateToFillWidth),
        _decoration.progress * 2,
        canvas,
        _foregroundPaint);
    _drawLineProgress(
        rect.bottomRight,
        rect.bottomLeft.translate(0.0, -translateToFillWidth),
        _decoration.progress * 2,
        canvas,
        _foregroundPaint);
    _drawLineProgress(
        rect.topRight,
        rect.bottomRight.translate(-translateToFillWidth, 0.0),
        _decoration.progress * 2 - 1,
        canvas,
        _foregroundPaint);
    _drawLineProgress(
        rect.bottomLeft,
        rect.topLeft.translate(translateToFillWidth, 0.0),
        _decoration.progress * 2 - 1,
        canvas,
        _foregroundPaint);
  }

  static void _drawLineProgress(
      Offset p1, Offset p2, double factor, Canvas canvas, Paint paint) {
    canvas.drawRect(
        Rect.fromPoints(p1, _lerpOffset(p1, p2, factor.clamp(0.0, 1.0))),
        paint);
  }

  static Offset _lerpOffset(Offset p1, Offset p2, double factor) {
    assert(factor >= 0.0 && factor <= 1.0);
    return Offset(
        lerpDouble(p1.dx, p2.dx, factor)!, lerpDouble(p1.dy, p2.dy, factor)!);
  }
}