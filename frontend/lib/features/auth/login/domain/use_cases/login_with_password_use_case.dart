import 'package:flutter_shelf_auth_module/features/auth/login/domain/repositories/i_login_repository.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';

abstract interface class ILoginWithPasswordUseCase {
  Future<UserEntity> call(String identifier, String password);
}

@LazySingleton(as: ILoginWithPasswordUseCase)
class LoginWithPasswordUseCaseImpl implements ILoginWithPasswordUseCase {
  final ILoginRepository _repository;

  const LoginWithPasswordUseCaseImpl(this._repository);

  @override
  Future<UserEntity> call(String identifier, String password) =>
      _repository.loginWithPassword(identifier, password);
}
