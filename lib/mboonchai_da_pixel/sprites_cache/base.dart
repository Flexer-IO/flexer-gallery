import 'pixels/pixel.dart';

abstract class SpriteCache {
    set(String key, PixelData data);
    PixelData? get(String key);
    bool has(String key);
}


