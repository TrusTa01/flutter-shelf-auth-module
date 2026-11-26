import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_shelf_auth_module/core/network/dio_client.dart';
import 'package:flutter_shelf_auth_module/core/storage/secure_storage/secure_storage_factory.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  FlutterSecureStorage get secureStorage => SecureStorageFactory.create();

  @singleton
  Talker get talker => Talker();

  @lazySingleton
  Dio dio(DioClient dioClient) => dioClient;
}
