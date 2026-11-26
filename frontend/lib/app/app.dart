import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shelf_auth_module/app/app_global_listeners.dart';
import 'package:flutter_shelf_auth_module/core/di/locator.dart';
import 'package:flutter_shelf_auth_module/core/extensions/l10n_ext.dart';
import 'package:flutter_shelf_auth_module/core/l10n/app_localization_setup.dart';
import 'package:flutter_shelf_auth_module/core/l10n/cubit/l10n_cubit.dart';
import 'package:flutter_shelf_auth_module/core/theme/cubit/theme_cubit.dart';
import 'package:flutter_shelf_auth_module/core/theme/theme_catalog.dart';
import 'package:flutter_shelf_auth_module/core/theme/theme_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AuthModuleApp extends StatelessWidget {
  const AuthModuleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.select((L10nCubit c) => c.state.locale);
    final themePrefs = context.select((ThemeCubit c) => c.state);
    final pair = themePairForPalette(themePrefs.activePalette);

    return AppGlobalListeners(
      child: MaterialApp.router(
        // locale
        onGenerateTitle: (context) => context.l10n.appTitle,
        localizationsDelegates: AppLocalizationSetup.delegates,
        supportedLocales: AppLocalizationSetup.supportedLocales,
        locale: locale,
        // router
        routerConfig: appRouter.config(
          navigatorObservers: () => [
            AutoRouteObserver(),
            TalkerRouteObserver(talker),
          ],
        ),
        // theme
        theme: pair.light,
        darkTheme: pair.dark,
        themeMode: themePrefs.brightness.asThemeMode,
        // other
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
