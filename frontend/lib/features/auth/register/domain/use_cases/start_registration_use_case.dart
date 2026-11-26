import 'package:flutter_shelf_auth_module/features/auth/register/domain/repositories/i_register_repository.dart';
import 'package:injectable/injectable.dart';

abstract interface class IStartRegistrationUseCase {
  Future<String> call({
    required String login,
    required String email,
    required String password,
  });
}

@LazySingleton(as: IStartRegistrationUseCase)
class StartRegistrationUseCaseImpl implements IStartRegistrationUseCase {
  final IRegisterRepository _repository;

  const StartRegistrationUseCaseImpl(this._repository);

  @override
  Future<String> call({
    required String login,
    required String email,
    required String password,
  }) => _repository.startRegistration(
    login: login,
    email: email,
    password: password,
  );
}
