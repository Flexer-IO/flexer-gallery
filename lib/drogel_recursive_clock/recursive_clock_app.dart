import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'clock/inherited/clock_updater.dart';
import 'clock/model/time.dart';
import 'clock/view/recursive_clock.dart';
import 'clock/view_model/clock_state.dart';
import 'clock/view_model/clock_view_model.dart';
import 'clock_info_layout.dart';
import 'color/inherited/color_updater.dart';
import 'info/inherited/info_updater.dart';
import 'info/view/info_panel.dart';
import 'info/view_model/info_state.dart';
import 'info/view_model/info_view_model.dart';

/// A widget that handles dependency injection for the Recursive Clock app.
class RecursiveClockApp extends StatelessWidget {
  const RecursiveClockApp(this._model);

  final ClockModel _model;

  @override
  Widget build(BuildContext context) => ColorUpdater(
        child: InfoUpdater(
          InfoViewModel(
            stateController: StreamController<InfoState>(),
            model: _model,
          ),
          child: ClockUpdater(
            ClockViewModel(
              stateController: StreamController<ClockState>(),
              model: const Time(),
            ),
            child: const ClockInfoLayout(
              infoPanel: InfoPanel(),
              clock: RecursiveClock(),
            ),
          ),
        ),
      );
}
