import 'dart:typed_data' show Float32List;
import 'dart:ui';

import '../cache/matrix_pool.dart' show pathTransform;

export 'dart:ui' show Path;

extension PathExtension on Path {
  Path transform32(Float32List matrix4) {
    return pathTransform(this, matrix4);
  }
}
