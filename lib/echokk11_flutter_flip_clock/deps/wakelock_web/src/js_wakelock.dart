@JS('Wakelock')
library wakelock.js;

import 'package:js/js.dart';
import './promise.dart';

/// Toggles the JS wakelock.
external void toggle(bool enable);

/// Returns a JS promise of whether the wakelock is enabled or not.
external PromiseJsImpl<bool> enabled();
