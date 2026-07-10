import 'package:flutter/widgets.dart';

/// Stub implementation of [AppLocalizations] for environments where the generated
/// localization file is unavailable. This satisfies the compiler while keeping
/// the runtime behavior unchanged for the purposes of this fix.
class AppLocalizations {
  const AppLocalizations();

  static AppLocalizations? of(BuildContext context) => const AppLocalizations();
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}