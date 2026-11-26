import 'package:flutter_shelf_auth_module/features/auth/login/domain/repositories/i_login_repository.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';

abstract interface class ILoginVerifyCodeUseCase {
  Future<UserEntity> call(String identifier, String code);
}

@LazySingleton(as: ILoginVerifyCodeUseCase)
class LoginVerifyCodeUseCaseImpl implements ILoginVerifyCodeUseCase {
  final ILoginRepository _repository;

  const LoginVerifyCodeUseCaseImpl(this._repository);

  @override
  Future<UserEntity> call(String identifier, String code) =>
      _repository.verifyLoginCode(identifier, code);
}
