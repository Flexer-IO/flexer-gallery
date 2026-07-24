import '../gpu/gpu.dart' as gpu;
import '../light.dart';
import './material.dart';
import '../shaders.dart';
import '../render/frame_transients.dart';

/// The material for `SplatGeometry`: evaluates the Gaussian falloff over
/// each footprint and outputs linear HDR premultiplied alpha.
///
/// Splats are always translucent (drawn depth-sorted in the renderer's
/// translucent phase, skipping the shadow and depth passes) and unlit; the
/// captured colors already bake in the capture's lighting. All tuning knobs
/// (opacity, tint, footprint scale, SH degree) live on the geometry, which
/// owns the per-splat data.
/// {@category Materials}
class SplatMaterial extends Material {
  /// Creates a [SplatMaterial] wrapping the `SplatsFragment` shader from
  /// [baseShaderLibrary].
  SplatMaterial() {
    setFragmentShaderName('SplatsFragment');
  }

  // Splats always blend and never write depth or cast shadows.
  @override
  bool isOpaque() => false;

  @override
  void bind(
    gpu.RenderPass pass,
    TransientWriter transientsBuffer,
    Lighting lighting,
  ) {
    super.bind(pass, transientsBuffer, lighting);
    // A screen-space footprint has no meaningful winding; cull nothing.
    pass.setCullMode(gpu.CullMode.none);
    // The fragment stage reads only varyings; there are no material
    // uniforms to bind.
  }
}
