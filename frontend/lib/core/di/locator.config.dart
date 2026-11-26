// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:flutter_shelf_auth_module/core/auth/infrastructure/i_session_expired_handler.dart'
    as _i4;
import 'package:flutter_shelf_auth_module/core/auth/infrastructure/session_expired_handler.dart'
    as _i244;
import 'package:flutter_shelf_auth_module/core/di/modules.dart' as _i50;
import 'package:flutter_shelf_auth_module/core/l10n/cubit/l10n_cubit.dart'
    as _i487;
import 'package:flutter_shelf_auth_module/core/network/dio_client.dart'
    as _i561;
import 'package:flutter_shelf_auth_module/core/storage/secure_storage/app_secure_storage.dart'
    as _i902;
import 'package:flutter_shelf_auth_module/core/storage/shared_preferences/app_prefs.dart'
    as _i573;
import 'package:flutter_shelf_auth_module/core/theme/cubit/theme_cubit.dart'
    as _i833;
import 'package:flutter_shelf_auth_module/core/theme/theme_controller.dart'
    as _i697;
import 'package:flutter_shelf_auth_module/features/account/presentation/cubit/account_cubit.dart'
    as _i998;
import 'package:flutter_shelf_auth_module/features/auth/login/data/data_sources/login_remote_data_source.dart'
    as _i1011;
import 'package:flutter_shelf_auth_module/features/auth/login/data/repositories/login_repository_impl.dart'
    as _i603;
import 'package:flutter_shelf_auth_module/features/auth/login/domain/repositories/i_login_repository.dart'
    as _i622;
import 'package:flutter_shelf_auth_module/features/auth/login/domain/use_cases/login_verify_code_use_case.dart'
    as _i328;
import 'package:flutter_shelf_auth_module/features/auth/login/domain/use_cases/login_with_code_use_case.dart'
    as _i519;
import 'package:flutter_shelf_auth_module/features/auth/login/domain/use_cases/login_with_password_use_case.dart'
    as _i110;
import 'package:flutter_shelf_auth_module/features/auth/login/presentation/cubit/login_cubit.dart'
    as _i427;
import 'package:flutter_shelf_auth_module/features/auth/register/data/data_sources/register_remote_data_source.dart'
    as _i1043;
import 'package:flutter_shelf_auth_module/features/auth/register/data/repositories/register_repository_impl.dart'
    as _i1005;
import 'package:flutter_shelf_auth_module/features/auth/register/domain/repositories/i_register_repository.dart'
    as _i378;
import 'package:flutter_shelf_auth_module/features/auth/register/domain/use_cases/cancel_registration_use_case.dart'
    as _i893;
import 'package:flutter_shelf_auth_module/features/auth/register/domain/use_cases/complete_registration_use_case.dart'
    as _i281;
import 'package:flutter_shelf_auth_module/features/auth/register/domain/use_cases/start_registration_use_case.dart'
    as _i978;
import 'package:flutter_shelf_auth_module/features/auth/register/domain/use_cases/verify_registration_email_use_case.dart'
    as _i548;
import 'package:flutter_shelf_auth_module/features/auth/register/presentation/cubit/register_cubit.dart'
    as _i214;
import 'package:flutter_shelf_auth_module/features/auth/session/data/data_sources/session_remote_data_source.dart'
    as _i332;
import 'package:flutter_shelf_auth_module/features/auth/session/data/repositories/session_repository_impl.dart'
    as _i37;
import 'package:flutter_shelf_auth_module/features/auth/session/domain/repositories/i_session_repository.dart'
    as _i407;
import 'package:flutter_shelf_auth_module/features/auth/session/domain/use_cases/get_current_user_use_case.dart'
    as _i973;
import 'package:flutter_shelf_auth_module/features/auth/session/domain/use_cases/logout_use_case.dart'
    as _i319;
import 'package:flutter_shelf_auth_module/features/auth/shared/presentation/cubit/auth_cubit.dart'
    as _i122;
import 'package:flutter_shelf_auth_module/router/app_router.dart' as _i327;
import 'package:flutter_shelf_auth_module/router/auth_guard.dart' as _i849;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:talker_flutter/talker_flutter.dart' as _i207;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i207.Talker>(() => registerModule.talker);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i697.ThemeController>(() => _i697.ThemeController());
    gh.lazySingleton<_i902.AppSecureStorage>(
      () => _i902.AppSecureStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i4.ISessionExpiredHandler>(
      () => _i244.SessionExpiredHandlerImpl(),
    );
    gh.lazySingleton<_i573.AppPrefs>(
      () => _i573.AppPrefs(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i561.DioClient>(
      () => _i561.DioClient(
        gh<_i207.Talker>(),
        gh<_i902.AppSecureStorage>(),
        gh<_i4.ISessionExpiredHandler>(),
      ),
    );
    gh.factory<_i487.L10nCubit>(() => _i487.L10nCubit(gh<_i573.AppPrefs>()));
    gh.factory<_i833.ThemeCubit>(() => _i833.ThemeCubit(gh<_i573.AppPrefs>()));
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<_i561.DioClient>()),
    );
    gh.lazySingleton<_i1011.LoginRemoteDataSource>(
      () => _i1011.LoginRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i1043.RegisterRemoteDataSource>(
      () => _i1043.RegisterRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i332.SessionRemoteDataSource>(
      () => _i332.SessionRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i622.ILoginRepository>(
      () => _i603.LoginRepositoryImpl(
        gh<_i1011.LoginRemoteDataSource>(),
        gh<_i902.AppSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i378.IRegisterRepository>(
      () =>
          _i1005.RegisterRepositoryImpl(gh<_i1043.RegisterRemoteDataSource>()),
    );
    gh.lazySingleton<_i328.ILoginVerifyCodeUseCase>(
      () => _i328.LoginVerifyCodeUseCaseImpl(gh<_i622.ILoginRepository>()),
    );
    gh.lazySingleton<_i110.ILoginWithPasswordUseCase>(
      () => _i110.LoginWithPasswordUseCaseImpl(gh<_i622.ILoginRepository>()),
    );
    gh.lazySingleton<_i407.ISessionRepository>(
      () => _i37.SessionRepositoryImpl(
        gh<_i332.SessionRemoteDataSource>(),
        gh<_i902.AppSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i519.ILoginWithCodeUseCase>(
      () => _i519.LoginWithCodeUseCaseImpl(gh<_i622.ILoginRepository>()),
    );
    gh.lazySingleton<_i281.ICompleteRegistrationUseCase>(
      () => _i281.CompleteRegistrationUseCaseImpl(
        gh<_i378.IRegisterRepository>(),
      ),
    );
    gh.lazySingleton<_i548.IVerifyRegistrationEmailUseCase>(
      () => _i548.VerifyRegistrationEmailUseCaseImpl(
        gh<_i378.IRegisterRepository>(),
      ),
    );
    gh.lazySingleton<_i893.ICancelRegistrationUseCase>(
      () =>
          _i893.CancelRegistrationUseCaseImpl(gh<_i378.IRegisterRepository>()),
    );
    gh.lazySingleton<_i319.ILogoutUseCase>(
      () => _i319.LogoutUseCaseImpl(gh<_i407.ISessionRepository>()),
    );
    gh.lazySingleton<_i973.IGetCurrentUserUseCase>(
      () => _i973.GetCurrentUserUseCaseImpl(gh<_i407.ISessionRepository>()),
    );
    gh.lazySingleton<_i978.IStartRegistrationUseCase>(
      () => _i978.StartRegistrationUseCaseImpl(gh<_i378.IRegisterRepository>()),
    );
    gh.lazySingleton<_i122.AuthCubit>(
      () => _i122.AuthCubit(
        gh<_i902.AppSecureStorage>(),
        gh<_i973.IGetCurrentUserUseCase>(),
        gh<_i4.ISessionExpiredHandler>(),
      ),
    );
    gh.factory<_i998.AccountCubit>(
      () => _i998.AccountCubit(
        gh<_i973.IGetCurrentUserUseCase>(),
        gh<_i319.ILogoutUseCase>(),
        gh<_i122.AuthCubit>(),
      ),
    );
    gh.factory<_i427.LoginCubit>(
      () => _i427.LoginCubit(
        gh<_i110.ILoginWithPasswordUseCase>(),
        gh<_i519.ILoginWithCodeUseCase>(),
        gh<_i328.ILoginVerifyCodeUseCase>(),
        gh<_i122.AuthCubit>(),
      ),
    );
    gh.factory<_i214.RegisterCubit>(
      () => _i214.RegisterCubit(
        gh<_i978.IStartRegistrationUseCase>(),
        gh<_i548.IVerifyRegistrationEmailUseCase>(),
        gh<_i281.ICompleteRegistrationUseCase>(),
        gh<_i893.ICancelRegistrationUseCase>(),
        gh<_i110.ILoginWithPasswordUseCase>(),
        gh<_i122.AuthCubit>(),
      ),
    );
    gh.lazySingleton<_i849.AuthGuard>(
      () => _i849.AuthGuard(gh<_i122.AuthCubit>()),
    );
    gh.lazySingleton<_i327.AppRouter>(
      () => _i327.AppRouter(gh<_i849.AuthGuard>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i50.RegisterModule {}
