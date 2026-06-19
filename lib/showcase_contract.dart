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

/// Dispatched by an in-showcase overlay (e.g. a scrollable drawer) when a
/// trackpad pan/zoom starts over it, so the host does not treat that gesture
/// as a "swipe to exit" the showcase.
class ShowcasePopVetoNotification extends Notification {
  const ShowcasePopVetoNotification();
}
