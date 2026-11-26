import 'package:flutter_shelf_auth_module/features/auth/session/domain/repositories/i_session_repository.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';

abstract interface class IGetCurrentUserUseCase {
  Future<UserEntity> call();
}

@LazySingleton(as: IGetCurrentUserUseCase)
class GetCurrentUserUseCaseImpl implements IGetCurrentUserUseCase {
  final ISessionRepository _repository;

  const GetCurrentUserUseCaseImpl(this._repository);

  @override
  Future<UserEntity> call() => _repository.getCurrentUser();
}
