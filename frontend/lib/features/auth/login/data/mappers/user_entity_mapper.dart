import 'package:flutter_shelf_auth_module/features/auth/shared/data/models/user/user_dto.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/domain/entities/user_entity.dart';

extension UserEntityMapper on UserDto {
  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    username: username,
    displayName: displayName,
    createdAt: createdAt,
  );
}
