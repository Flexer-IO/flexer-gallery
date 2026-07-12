import 'package:flutter/widgets.dart';
import '../../deps/flutter_gen/gen_l10n/app_localizations.dart';

export '../../deps/flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}