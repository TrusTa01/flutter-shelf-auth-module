import 'package:dio/dio.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/data/auth_api_path_enum.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/data/models/user/user_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SessionRemoteDataSource {
  final Dio _dio;

  const SessionRemoteDataSource(this._dio);

  Future<UserDto> getMe() async {
    final response = await _dio.get(AuthApiPathEnum.me.path);
    return UserDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> logout() => _dio.post(AuthApiPathEnum.logout.path);

  Future<void> logoutAll() => _dio.post(AuthApiPathEnum.logoutAll.path);
}
