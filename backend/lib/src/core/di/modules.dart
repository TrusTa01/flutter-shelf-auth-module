import 'package:backend/src/core/config/db_config.dart';
import 'package:injectable/injectable.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:talker/talker.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Router get router => Router();

  @lazySingleton
  Talker get talker => Talker();

  @lazySingleton
  DbConfig get dbConfig => DbConfig.fromEnvironment(readEnvironment());

  @lazySingleton
  Pool<Connection> pool(DbConfig config) {
    final endpoint = Endpoint(
      host: config.host,
      port: config.port,
      database: config.database,
      username: config.username,
      password: config.password,
    );

    return Pool.withEndpoints([
      endpoint,
    ], settings: PoolSettings(maxConnectionCount: 5, sslMode: SslMode.disable));
  }
}
