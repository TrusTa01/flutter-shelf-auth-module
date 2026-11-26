import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shelf_auth_module/core/di/locator.dart';
import 'package:flutter_shelf_auth_module/core/extensions/l10n_ext.dart';
import 'package:flutter_shelf_auth_module/core/extensions/theme_context_ext.dart';
import 'package:flutter_shelf_auth_module/features/account/presentation/cubit/account_cubit.dart';
import 'package:flutter_shelf_auth_module/features/account/presentation/cubit/account_state.dart';
import 'package:flutter_shelf_auth_module/features/auth/session/presentation/extensions/session_failure_message.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/domain/entities/user_entity.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/presentation/widgets/ui_kits/app_snack_bar.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/presentation/widgets/ui_kits/loading_button.dart';
import 'package:flutter_shelf_auth_module/features/auth/shared/presentation/widgets/ui_kits/theme_switcher_icon.dart';

@RoutePage()
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AccountCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(context.appIconLogoPath, height: 64, width: 64),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: ThemeSwitcherIcon(),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocConsumer<AccountCubit, AccountState>(
            listenWhen: (_, current) => current is AccountActionError,
            listener: (context, state) {
              if (state is AccountActionError) {
                context.showAppSnackBar(state.failure.messages(context.l10n));
              }
            },
            builder: (context, state) => switch (state) {
              AccountLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              AccountLoadError(:final failure) => _LoadErrorView(
                message: failure.messages(context.l10n),
                onRetry: context.read<AccountCubit>().load,
              ),
              AccountLoaded() => _AccountView(state: state),
            },
          ),
        ),
      ),
    );
  }
}

class _AccountView extends StatelessWidget {
  final AccountLoaded state;

  const _AccountView({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<AccountCubit>();
    final user = state.user;
    final pending = state.pendingAction;
    final isBusy = pending != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  _ProfileHeader(user: user),
                  const SizedBox(height: 32),
                  _ProfileDetails(user: user),

                  const Spacer(),
                  const SizedBox(height: 32),

                  // Log out (this device)
                  FilledButton(
                    onPressed: isBusy ? null : cubit.logout,
                    child: LoadingButton(
                      state: pending == AccountAction.logout,
                      text: Text(l10n.logOut),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Log out of all devices
                  OutlinedButton(
                    onPressed: isBusy ? null : cubit.logoutAll,
                    child: LoadingButton(
                      state: pending == AccountAction.logoutAll,
                      text: Text(l10n.logOutAllDevices),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final initial = user.displayName.trim().isEmpty
        ? '?'
        : user.displayName.trim().characters.first.toUpperCase();

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: colors.primaryContainer,
            foregroundColor: colors.onPrimaryContainer,
            child: Text(initial, style: const TextStyle(fontSize: 32)),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          user.displayName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 5),
        Text(
          '@${user.username}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  final UserEntity user;

  const _ProfileDetails({required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final memberSince = MaterialLocalizations.of(
      context,
    ).formatMediumDate(user.createdAt.toLocal());

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Same neutral fill as the input fields: the brand theme maps the default
    // card colour to the primary purple, which hides the text in light mode.
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: theme.inputDecorationTheme.fillColor,
      child: ListTileTheme(
        data: ListTileThemeData(
          iconColor: colors.primary,
          textColor: colors.onSurface,
          subtitleTextStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurface.withValues(alpha: 0.65),
          ),
        ),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.alternate_email),
              title: Text(l10n.accountEmailLabel),
              subtitle: Text(user.email),
            ),
            ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: Text(l10n.profileSetupUsernameLabel),
              subtitle: Text(user.username),
            ),
            ListTile(
              leading: const Icon(Icons.event_outlined),
              title: Text(l10n.accountMemberSince),
              subtitle: Text(memberSince),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _LoadErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: Text(context.l10n.retry)),
          ],
        ),
      ),
    );
  }
}
