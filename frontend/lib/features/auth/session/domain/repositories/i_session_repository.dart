import 'package:flutter_shelf_auth_module/features/auth/shared/domain/entities/user_entity.dart';

abstract interface class ISessionRepository {
  Future<UserEntity> getCurrentUser();
  Future<void> logout();
  Future<void> logoutAll();
}
