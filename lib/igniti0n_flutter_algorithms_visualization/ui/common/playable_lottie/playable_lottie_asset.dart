enum PlayableLottieAsset {
  goalFlag,
  trashBin,
  maze,
}

extension PlayableLottieAssetUtils on PlayableLottieAsset {
  static const String _basePath = 'packages/showcase_library/assets/igniti0n_flutter_algorithms_visualization/lotties/';
  static const _paths = {
    PlayableLottieAsset.goalFlag: '${_basePath}flag_with_sparkle.json',
    PlayableLottieAsset.trashBin: '${_basePath}delete.json',
    PlayableLottieAsset.maze: '${_basePath}maze.json'
  };

  String get pathToAsset => _paths[this]!;
}
