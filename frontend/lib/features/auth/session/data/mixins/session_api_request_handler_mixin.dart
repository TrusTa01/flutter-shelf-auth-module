import 'package:dio/dio.dart';
import 'package:flutter_shelf_auth_module/core/network/errors/api_exception.dart';
import 'package:flutter_shelf_auth_module/features/auth/session/domain/failures/session_failure.dart';

mixin SessionApiRequestHandler {
  Future<E> safeApiCall<T, E>({
    required Future<T> Function() request,
    E Function(T dto)? mapper,
  }) async {
    try {
      final response = await request.call();
      if (mapper != null) return mapper(response);
      return null as E;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Exception _handleDioError(DioException error) {
    final api = error.error;
    if (api is ApiException) {
      switch (api.code) {
        case 'UNAUTHORIZED':
          throw const SessionUnauthorizedFailure();
        default:
          throw UnknownSessionFailure(api.message);
      }
    }
    throw const SessionNetworkFailure();
  }
}
