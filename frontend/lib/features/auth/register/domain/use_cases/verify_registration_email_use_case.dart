import 'package:flutter_shelf_auth_module/features/auth/register/domain/repositories/i_register_repository.dart';
import 'package:injectable/injectable.dart';

abstract interface class IVerifyRegistrationEmailUseCase {
  Future<void> call({required String registrationId, required String code});
}

@LazySingleton(as: IVerifyRegistrationEmailUseCase)
class VerifyRegistrationEmailUseCaseImpl
    implements IVerifyRegistrationEmailUseCase {
  final IRegisterRepository _repository;

  const VerifyRegistrationEmailUseCaseImpl(this._repository);

  @override
  Future<void> call({required String registrationId, required String code}) =>
      _repository.verifyRegistrationEmail(
        registrationId: registrationId,
        code: code,
      );
}
