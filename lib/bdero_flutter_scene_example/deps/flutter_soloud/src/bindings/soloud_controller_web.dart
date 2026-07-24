// ignore_for_file: public_member_api_docs

import './bindings_player_web.dart';

/// Controller that expose FFI.
class SoLoudController {
  factory SoLoudController() => _instance ??= SoLoudController._();

  SoLoudController._();

  static SoLoudController? _instance;

  final FlutterSoLoudWeb _soLoudFFI = FlutterSoLoudWeb();

  FlutterSoLoudWeb get soLoudFFI => _soLoudFFI;
}
