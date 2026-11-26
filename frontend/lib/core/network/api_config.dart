abstract final class ApiConfig {
  /// Override with `--dart-define=API_BASE_URL=http://host:port`.
  /// Default points at the host machine from the Android emulator.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8082',
  );
  static Duration get connectTimeout => const Duration(seconds: 15);
  static Duration get receiveTimeout => const Duration(seconds: 15);
}
