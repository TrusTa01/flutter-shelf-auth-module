import 'package:flutter_shelf_auth_module/features/auth/session/domain/repositories/i_session_repository.dart';
import 'package:injectable/injectable.dart';

abstract interface class ILogoutUseCase {
  /// Revokes the current session, or every session of the user when [allDevices].
  Future<void> call({bool allDevices = false});
}

@LazySingleton(as: ILogoutUseCase)
class LogoutUseCaseImpl implements ILogoutUseCase {
  final ISessionRepository _repository;

  const LogoutUseCaseImpl(this._repository);

  @override
  Future<void> call({bool allDevices = false}) =>
      allDevices ? _repository.logoutAll() : _repository.logout();
}
