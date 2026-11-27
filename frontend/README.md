# Auth client (Flutter)

Flutter client of the auth module: welcome screen, sign-in by password or e-mail code, three-step registration, account screen. The backend is in [`../backend`](../backend); the overview is in the [root README](../README.md).

## Run

The backend must be running (`docker compose up` in `../docker`).

```bash
flutter pub get
flutter run                                                   # Android emulator
```

| Device | Command |
|---|---|
| Android emulator | `flutter run` (default `http://10.0.2.2:8082`) |
| Phone over USB | `adb reverse tcp:8082 tcp:8082`, then `flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8082` |
| Other host | `flutter run --dart-define=API_BASE_URL=http://<host>:8082` |

## Code generation

Generated files are committed. After changing models, DI annotations or routes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Localizations are generated from `lib/core/l10n/*.arb` by `flutter gen-l10n` (configured in `l10n.yaml`).

## Structure

```
lib/
├── main.dart
├── app/                 # root widget, providers
├── router/              # auto_route, AuthGuard
├── core/
│   ├── auth/            # session expiry handling
│   ├── di/              # get_it + injectable
│   ├── network/         # Dio, interceptors, API_BASE_URL
│   ├── storage/         # secure storage (token), shared preferences
│   ├── theme/           # light/dark themes, palettes
│   ├── l10n/            # ARB files, generated localizations
│   └── layouts/         # shared auth layout
└── features/
    ├── auth/            # welcome, login, register, session
    └── account/         # account screen
```
