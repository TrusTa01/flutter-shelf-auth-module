import 'package:flutter_shelf_auth_module/features/auth/session/domain/failures/session_failure.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/domain/entities/user_entity.dart';

enum AccountAction { logout, logoutAll }

sealed class AccountState {
  const AccountState();
}

final class AccountLoading extends AccountState {
  const AccountLoading();
}

/// Profile is shown; [pendingAction] is set while a logout request runs.
final class AccountLoaded extends AccountState {
  final UserEntity user;
  final AccountAction? pendingAction;
  const AccountLoaded(this.user, {this.pendingAction});
}

/// The profile could not be loaded; the screen offers a retry.
final class AccountLoadError extends AccountState {
  final SessionFailure failure;
  const AccountLoadError(this.failure);
}

/// A logout request failed; the profile stays on screen.
final class AccountActionError extends AccountLoaded {
  final SessionFailure failure;
  const AccountActionError(super.user, this.failure);
}
