import 'package:flutter_shelf_auth_module/core/di/locator.config.dart';
import 'package:flutter_shelf_auth_module/core/theme/theme_controller.dart';
import 'package:flutter_shelf_auth_module/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:flutter_shelf_auth_module/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:flutter_shelf_auth_module/router/app_router.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

AppRouter get appRouter => getIt<AppRouter>();
Talker get talker => getIt<Talker>();
ThemeController get themeController => getIt<ThemeController>();
LoginCubit get loginCubit => getIt<LoginCubit>();
RegisterCubit get registerCubit => getIt<RegisterCubit>();
