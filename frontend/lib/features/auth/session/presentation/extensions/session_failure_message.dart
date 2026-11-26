import 'package:flutter_shelf_auth_module/core/l10n/gen/app_localizations.dart';
import 'package:flutter_shelf_auth_module/features/auth/session/domain/failures/session_failure.dart';

extension SessionFailureMessage on SessionFailure {
  String messages(AppLocalizations l10n) => switch (this) {
    SessionUnauthorizedFailure() => l10n.sessionExpired,
    SessionNetworkFailure() => l10n.networkError,
    UnknownSessionFailure(:final message) => message,
  };
}
