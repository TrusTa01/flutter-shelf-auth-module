import 'dart:async';

import 'package:flutter_shelf_auth_module/core/auth/infrastructure/i_session_expired_handler.dart';
import 'package:injectable/injectable.dart';

/// A signal between the network layer and `AuthCubit`.
///
/// It must not depend on AuthCubit directly: AuthCubit -> session use cases ->
/// Dio -> ErrorInterceptor -> this handler would be a DI cycle.
@LazySingleton(as: ISessionExpiredHandler)
class SessionExpiredHandlerImpl implements ISessionExpiredHandler {
  final _controller = StreamController<void>.broadcast();

  @override
  Stream<void> get sessionExpired => _controller.stream;

  @override
  void onSessionExpired() => _controller.add(null);
}
