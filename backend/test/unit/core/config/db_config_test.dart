import 'dart:io';

import 'package:backend/src/core/config/db_config.dart';
import 'package:test/test.dart';

void main() {
  const required = {
    'DB_NAME': 'auth_db',
    'DB_USER': 'auth_user',
    'DB_PASSWORD': 'secret',
  };

  group('DbConfig.fromEnvironment', () {
    test('uses defaults for host and port', () {
      final config = DbConfig.fromEnvironment(required);

      expect(config.host, 'localhost');
      expect(config.port, 5432);
      expect(config.database, 'auth_db');
      expect(config.username, 'auth_user');
      expect(config.password, 'secret');
    });

    test('reads host and port when provided', () {
      final config = DbConfig.fromEnvironment({
        ...required,
        'DB_HOST': 'postgres',
        'DB_PORT': '6543',
      });

      expect(config.host, 'postgres');
      expect(config.port, 6543);
    });

    for (final key in required.keys) {
      test('throws when $key is missing', () {
        final env = Map.of(required)..remove(key);
        expect(
          () => DbConfig.fromEnvironment(env),
          throwsA(isA<StateError>()),
        );
      });

      test('throws when $key is empty', () {
        final env = {...required, key: ''};
        expect(
          () => DbConfig.fromEnvironment(env),
          throwsA(isA<StateError>()),
        );
      });
    }

    test('throws on non-numeric DB_PORT', () {
      expect(
        () => DbConfig.fromEnvironment({...required, 'DB_PORT': 'abc'}),
        throwsA(isA<StateError>()),
      );
    });

    test('throws on out-of-range DB_PORT', () {
      expect(
        () => DbConfig.fromEnvironment({...required, 'DB_PORT': '70000'}),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('readEnvironment', () {
    test('merges values from a .env file when it exists', () {
      final dir = Directory.systemTemp.createTempSync('db_config_test');
      addTearDown(() => dir.deleteSync(recursive: true));
      final file = File('${dir.path}/.env')
        ..writeAsStringSync('DB_NAME=from_file\nUNRELATED=x\n');

      final env = readEnvironment(dotEnvPath: file.path);

      expect(env['DB_NAME'], Platform.environment['DB_NAME'] ?? 'from_file');
      expect(env.containsKey('UNRELATED'), isFalse);
    });

    test('does not fail when the .env file is absent', () {
      expect(
        () => readEnvironment(dotEnvPath: 'definitely-missing.env'),
        returnsNormally,
      );
    });
  });
}
