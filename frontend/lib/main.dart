import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shelf_auth_module/app/app.dart';
import 'package:flutter_shelf_auth_module/app/app_providers.dart';
import 'package:flutter_shelf_auth_module/core/di/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(
    MultiBlocProvider(
      providers: AppProviders.providers,
      child: const AuthModuleApp(),
    ),
  );
}
 