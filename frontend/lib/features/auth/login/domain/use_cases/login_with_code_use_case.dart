import 'package:flutter_shelf_auth_module/features/auth/login/domain/repositories/i_login_repository.dart';
import 'package:injectable/injectable.dart';

abstract interface class ILoginWithCodeUseCase {
  Future<void> call(String identifier);
}

@LazySingleton(as: ILoginWithCodeUseCase)
class LoginWithCodeUseCaseImpl implements ILoginWithCodeUseCase {
  final ILoginRepository _repository;

  const LoginWithCodeUseCaseImpl(this._repository);

  @override
  Future<void> call(String identifier) => _repository.loginWithCode(identifier);
}
