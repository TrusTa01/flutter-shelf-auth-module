import 'package:flutter/material.dart';
import 'package:flutter_shelf_auth_module/core/l10n/gen/app_localizations.dart';

extension LocalizedContextExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}