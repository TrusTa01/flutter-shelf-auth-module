import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shelf_auth_module/core/di/locator.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/presentation/cubit/auth_cubit.dart';
import 'package:flutter_shelf_auth_module/router/app_router.dart';

class AppGlobalListeners extends StatelessWidget {
  final Widget child;

  const AppGlobalListeners({super.key, required this.child});

  static const _loginStack = [
    WelcomeRoute(),
    AuthLayoutRoute(children: [LoginRoute()]),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // App start: the stored token is checked while Welcome is shown.
        // If the user has already left Welcome, don't pull them back.
        BlocListener<AuthCubit, AuthStatus>(
          listenWhen: (previous, _) => previous == AuthStatus.initial,
          listener: (context, state) {
            final router = getIt<AppRouter>();
            if (router.current.name != WelcomeRoute.name) return;

            switch (state) {
              case AuthStatus.authenticated:
                router.replaceAll([const AccountRoute()]);
              case AuthStatus.sessionExpired:
                router.replaceAll(_loginStack);
              case AuthStatus.initial:
              case AuthStatus.unauthenticated:
                break;
            }
          },
        ),

        // Logout, or a 401 on an authenticated request.
        BlocListener<AuthCubit, AuthStatus>(
          listenWhen: (previous, current) =>
              previous == AuthStatus.authenticated &&
              (current == AuthStatus.unauthenticated ||
                  current == AuthStatus.sessionExpired),
          listener: (context, _) => getIt<AppRouter>().replaceAll(_loginStack),
        ),
      ],
      child: child,
    );
  }
}
