/// Contract every showcase must implement.
/// Import this in your showcase_info.dart.
library;

import 'package:flutter/widgets.dart';

class ShowcaseInfo {
  const ShowcaseInfo({
    required this.showcaseName,
    required this.githubRepoUrl,
    this.orientation,
    this.description,
  });

  final String showcaseName;
  final String githubRepoUrl;

  /// null = system controls rotation freely
  final Orientation? orientation;
  final String? description;
}
