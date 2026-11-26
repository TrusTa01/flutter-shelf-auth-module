import 'package:flutter_shelf_auth_module/features/auth/register/domain/repositories/i_register_repository.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';

abstract interface class ICompleteRegistrationUseCase {
  Future<UserEntity> call({
    required String registrationId,
    required String username,
    required String displayName,
  });
}

@LazySingleton(as: ICompleteRegistrationUseCase)
class CompleteRegistrationUseCaseImpl implements ICompleteRegistrationUseCase {
  final IRegisterRepository _repository;

  const CompleteRegistrationUseCaseImpl(this._repository);

  @override
  Future<UserEntity> call({
    required String registrationId,
    required String username,
    required String displayName,
  }) => _repository.completeRegistration(
    registrationId: registrationId,
    username: username,
    displayName: displayName,
  );
}
