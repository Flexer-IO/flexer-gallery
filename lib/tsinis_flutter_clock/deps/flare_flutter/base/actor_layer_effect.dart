import './actor_artboard.dart';
import './actor_component.dart';
import './stream_reader.dart';

abstract class ActorLayerEffect extends ActorComponent {
  late bool _isActive;
  bool get isActive => _isActive;

  void copyLayerEffect(ActorLayerEffect from, ActorArtboard resetArtboard) {
    copyComponent(from, resetArtboard);
    _isActive = from._isActive;
  }

  static ActorLayerEffect read(
      ActorArtboard artboard, StreamReader reader, ActorLayerEffect component) {
    ActorComponent.read(artboard, reader, component);
    component._isActive = reader.readBool('isActive');

    return component;
  }
}
