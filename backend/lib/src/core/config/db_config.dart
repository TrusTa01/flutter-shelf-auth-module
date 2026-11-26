import 'dart:io';

import 'package:dotenv/dotenv.dart' as dotenv;

/// PostgreSQL connection settings read from environment variables.
///
/// Required: `DB_NAME`, `DB_USER`, `DB_PASSWORD`.
/// Optional: `DB_HOST` (default `localhost`), `DB_PORT` (default `5432`).
final class DbConfig {
  final String host;
  final int port;
  final String database;
  final String username;
  final String password;

  const DbConfig({
    required this.host,
    required this.port,
    required this.database,
    required this.username,
    required this.password,
  });

  factory DbConfig.fromEnvironment(Map<String, String> env) {
    String require(String key) {
      final value = env[key];
      if (value == null || value.isEmpty) {
        throw StateError('Missing required environment variable $key');
      }
      return value;
    }

    final rawPort = env['DB_PORT'];
    final port = rawPort == null || rawPort.isEmpty
        ? 5432
        : int.tryParse(rawPort);
    if (port == null || port <= 0 || port > 65535) {
      throw StateError('DB_PORT must be a valid port number, got "$rawPort"');
    }

    return DbConfig(
      host: env['DB_HOST']?.isNotEmpty == true ? env['DB_HOST']! : 'localhost',
      port: port,
      database: require('DB_NAME'),
      username: require('DB_USER'),
      password: require('DB_PASSWORD'),
    );
  }
}

/// Process environment, plus a local `.env` file when one exists.
///
/// The `.env` file is a local-development convenience; in Docker the
/// variables come from docker-compose and no file is shipped in the image.
Map<String, String> readEnvironment({String dotEnvPath = '.env'}) {
  final env = dotenv.DotEnv(includePlatformEnvironment: true, quiet: true);
  if (File(dotEnvPath).existsSync()) env.load([dotEnvPath]);
  return {
    for (final key in [
      'DB_HOST',
      'DB_PORT',
      'DB_NAME',
      'DB_USER',
      'DB_PASSWORD',
      'PORT',
    ])
      if (env[key] != null) key: env[key]!,
  };
}
