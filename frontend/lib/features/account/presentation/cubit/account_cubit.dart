import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shelf_auth_module/features/account/presentation/cubit/account_state.dart';
import 'package:flutter_shelf_auth_module/features/auth/session/domain/failures/session_failure.dart';
import 'package:flutter_shelf_auth_module/features/auth/session/domain/use_cases/get_current_user_use_case.dart';
import 'package:flutter_shelf_auth_module/features/auth/session/domain/use_cases/logout_use_case.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/presentation/cubit/auth_cubit.dart';
import 'package:injectable/injectable.dart';

@injectable
class AccountCubit extends Cubit<AccountState> {
  final IGetCurrentUserUseCase _getCurrentUserUseCase;
  final ILogoutUseCase _logoutUseCase;
  final AuthCubit _authCubit;

  AccountCubit(this._getCurrentUserUseCase, this._logoutUseCase, this._authCubit)
    : super(const AccountLoading());

  Future<void> load() async {
    emit(const AccountLoading());
    try {
      final user = await _getCurrentUserUseCase.call();
      emit(AccountLoaded(user));
    } on SessionFailure catch (f) {
      // A 401 is also reported to AuthCubit by the network layer,
      // which signs the user out globally.
      emit(AccountLoadError(f));
    }
  }

  Future<void> logout() => _logout(AccountAction.logout);

  Future<void> logoutAll() => _logout(AccountAction.logoutAll);

  Future<void> _logout(AccountAction action) async {
    final current = state;
    if (current is! AccountLoaded || current.pendingAction != null) return;

    emit(AccountLoaded(current.user, pendingAction: action));
    try {
      await _logoutUseCase.call(allDevices: action == AccountAction.logoutAll);
      await _authCubit.logout();
    } on SessionFailure catch (f) {
      emit(AccountActionError(current.user, f));
    }
  }
}
