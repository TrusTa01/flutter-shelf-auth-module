import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shelf_auth_module/core/auth/infrastructure/i_session_expired_handler.dart';
import 'package:flutter_shelf_auth_module/core/storage/secure_storage/app_secure_storage.dart';
import 'package:flutter_shelf_auth_module/features/auth/session/domain/failures/session_failure.dart';
import 'package:flutter_shelf_auth_module/features/auth/session/domain/use_cases/get_current_user_use_case.dart';
import 'package:injectable/injectable.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,

  /// The stored token was rejected by the server (expired or revoked).
  sessionExpired,
}

@lazySingleton
class AuthCubit extends Cubit<AuthStatus> {
  final AppSecureStorage _secureStorage;
  final IGetCurrentUserUseCase _getCurrentUserUseCase;
  late final StreamSubscription<void> _sessionExpiredSub;

  AuthCubit(
    this._secureStorage,
    this._getCurrentUserUseCase,
    ISessionExpiredHandler sessionExpiredHandler,
  ) : super(AuthStatus.initial) {
    _sessionExpiredSub = sessionExpiredHandler.sessionExpired.listen((_) {
      // checkAuth() handles its own 401, so react only to a live session.
      if (state == AuthStatus.authenticated) _expire();
    });
  }

  /// Validates the stored token with GET /auth/me.
  Future<void> checkAuth() async {
    final token = await _secureStorage.getToken();
    if (token == null) {
      emit(AuthStatus.unauthenticated);
      return;
    }

    try {
      await _getCurrentUserUseCase.call();
      emit(AuthStatus.authenticated);
    } on SessionUnauthorizedFailure {
      await _expire();
    } on SessionFailure {
      // Server unreachable: keep the session, the account screen can retry.
      emit(AuthStatus.authenticated);
    }
  }

  void setAuthenticated() => emit(AuthStatus.authenticated);
  void setUnauthenticated() => emit(AuthStatus.unauthenticated);

  /// Local sign-out: the server session must already be revoked.
  Future<void> logout() async {
    await _secureStorage.deleteToken();
    setUnauthenticated();
  }

  Future<void> _expire() async {
    await _secureStorage.deleteToken();
    emit(AuthStatus.sessionExpired);
  }

  @override
  Future<void> close() async {
    await _sessionExpiredSub.cancel();
    return super.close();
  }
}
