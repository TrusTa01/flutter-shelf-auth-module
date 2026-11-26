import 'package:auto_route/auto_route.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/presentation/cubit/auth_cubit.dart';
import 'package:flutter_shelf_auth_module/router/app_router.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthGuard extends AutoRouteGuard {
  final AuthCubit _authCubit;

  AuthGuard(this._authCubit);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isAuthenticated = _authCubit.state == AuthStatus.authenticated;

    if (isAuthenticated) {
      resolver.next(true);
      return;
    }

    resolver.next(false);
    router.replaceAll([const WelcomeRoute()]);
  }
}
