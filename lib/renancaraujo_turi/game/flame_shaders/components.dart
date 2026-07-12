import 'dart:ui';

import '../game.dart' hide SamplerOwner;
import 'sampler_canvas.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

/// Minimal stub for [FragmentShaderLayer] to satisfy compilation when the
/// real implementation is unavailable. It provides the constructor used in
/// [SamplerCamera] and a simple [render] implementation that forwards to the
/// supplied [preRender] callback.
class FragmentShaderLayer {
  final SamplerOwner owner;
  final FragmentShader shader;
  final void Function(Canvas) preRender;
  final Canvas Function(PictureRecorder, int) canvasCreator;
  final int passes;
  final Sampler sampler;
  final double pixelRatio;

  FragmentShaderLayer({
    required this.owner,
    required this.shader,
    required this.preRender,
    required this.canvasCreator,
    required this.passes,
    required this.sampler,
    required this.pixelRatio,
  });

  /// Renders the layer onto the given [canvas]. The real implementation would
  /// apply the shader; this stub simply invokes the pre‑render callback.
  void render(Canvas canvas, Size size) {
    preRender(canvas);
  }
}

class SamplerCamera<OwnerType extends SamplerOwner> extends CameraComponent {
  SamplerCamera({
    required this.samplerOwner,
    required this.pixelRatio,
    super.world,
    super.viewport,
    super.viewfinder,
    super.backdrop,
    super.hudComponents,
  }) {
    layer = FragmentShaderLayer(
      owner: samplerOwner,
      shader: samplerOwner.shader,
      preRender: _preRender,
      canvasCreator: _createCanvas,
      passes: samplerOwner.passes,
      sampler: samplerOwner.sampler,
      pixelRatio: pixelRatio,
    );

    samplerOwner.attachCamera(this);
  }

  /// Creates a [SamplerCamera] with a fixed resolution viewport.
  ///
  /// The generic type parameter [OwnerType] is bounded by [SamplerOwner] to
  /// ensure the supplied [samplerOwner] implements the required interface.
  factory SamplerCamera.withFixedResolution({
    required double width,
    required double height,
    required OwnerType samplerOwner,
    required double pixelRatio,
    Viewfinder? viewfinder,
    World? world,
    Component? backdrop,
    List<Component>? hudComponents,
  }) {
    return SamplerCamera<OwnerType>(
      samplerOwner: samplerOwner,
      pixelRatio: pixelRatio,
      world: world,
      viewport: FixedResolutionViewport(resolution: Vector2(width, height))
        ..addAll(hudComponents ?? []),
      viewfinder: viewfinder ?? Viewfinder(),
      backdrop: backdrop,
    );
  }

  final OwnerType samplerOwner;

  late final FragmentShaderLayer layer;

  final double pixelRatio;

  Canvas _createCanvas(PictureRecorder recorder, int pass) {
    return SamplerCanvas(
      owner: samplerOwner,
      actualCanvas: Canvas(recorder),
      pass: pass,
    );
  }

  void _preRender(Canvas canvas) {
    super.renderTree(canvas);
  }

  @override
  void renderTree(Canvas canvas) {
    final offset = viewport.position;
    canvas
      ..save()
      ..translate(offset.x, offset.y);
    layer.render(canvas, viewport.size.toSize());
    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    samplerOwner.update(dt);
  }
}