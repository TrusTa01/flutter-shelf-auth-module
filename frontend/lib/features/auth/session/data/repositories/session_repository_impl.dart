import 'package:flutter_shelf_auth_module/core/storage/secure_storage/app_secure_storage.dart';
import 'package:flutter_shelf_auth_module/features/auth/login/data/mappers/user_entity_mapper.dart';
import 'package:flutter_shelf_auth_module/features/auth/session/data/data_sources/session_remote_data_source.dart';
import 'package:flutter_shelf_auth_module/features/auth/session/data/mixins/session_api_request_handler_mixin.dart';
import 'package:flutter_shelf_auth_module/features/auth/session/domain/repositories/i_session_repository.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/data/models/user/user_dto.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ISessionRepository)
class SessionRepositoryImpl
    with SessionApiRequestHandler
    implements ISessionRepository {
  final SessionRemoteDataSource _dataSource;
  final AppSecureStorage _secureStorage;

  const SessionRepositoryImpl(this._dataSource, this._secureStorage);

  @override
  Future<UserEntity> getCurrentUser() => safeApiCall<UserDto, UserEntity>(
    request: _dataSource.getMe,
    mapper: (dto) => dto.toEntity(),
  );

  // The local token is cleared only after the server has revoked the session.
  @override
  Future<void> logout() async {
    await safeApiCall<void, void>(request: _dataSource.logout);
    await _secureStorage.deleteToken();
  }

  @override
  Future<void> logoutAll() async {
    await safeApiCall<void, void>(request: _dataSource.logoutAll);
    await _secureStorage.deleteToken();
  }
}
