import 'dart:async';
import 'dart:io';

import 'package:backend/src/middleware/auth_middleware.dart';
import 'package:backend/src/middleware/error_middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:backend/src/core/config/db_config.dart';
import 'package:backend/src/core/di/locator.dart';
import 'package:backend/src/middleware/logging_middleware.dart';
import 'package:postgres/postgres.dart';

/// Builds the middleware pipeline, starts the HTTP server and blocks until
/// SIGINT/SIGTERM. Shared by `bin/server.dart` and `bin/server.dev.dart`.
Future<void> runServer() async {
  HttpServer? server;
  Pool<Connection>? dbPool;
  final port = int.tryParse(readEnvironment()['PORT'] ?? '') ?? 8082;

  try {
    // di
    await configureDependencies();

    // db
    dbPool = pool;
    talker.info('Database pool initialized');

    // http pipeline
    final handler = const Pipeline()
        .addMiddleware(LoggingMiddleware.talkerMiddleware(talker))
        .addMiddleware(errorMiddleware())
        .addMiddleware(authMiddleware())
        .addHandler(appModule.handler);

    // server
    server = await shelf_io.serve(
      handler,
      InternetAddress.anyIPv4,
      port,
      shared: false,
    );
    server.autoCompress = true;
    final bindHost = server.address.host;
    final publicHost =
        (bindHost == InternetAddress.anyIPv4.host ||
            bindHost == InternetAddress.anyIPv6.host)
        ? 'localhost'
        : bindHost;
    talker.info(
      'Server started successfully! \npublic host: http://$publicHost:${server.port}\nserver host: http://${server.address.host}:${server.port}',
    );

    // graceful shutdown
    final stop = Completer<void>();
    var shuttingDown = false;
    late final StreamSubscription<ProcessSignal> sigintSub;
    StreamSubscription<ProcessSignal>? sigtermSub;

    Future<void> shutDown(String signal) async {
      if (shuttingDown) return;
      shuttingDown = true;
      talker.warning('Received $signal, shutting down...');
      await sigintSub.cancel();
      await sigtermSub?.cancel();
      await server?.close(force: true);
      await dbPool?.close();
      if (!stop.isCompleted) stop.complete();
    }

    sigintSub = ProcessSignal.sigint.watch().listen((_) {
      unawaited(shutDown('SIGINT'));
    });
    if (!Platform.isWindows) {
      sigtermSub = ProcessSignal.sigterm.watch().listen((_) {
        unawaited(shutDown('SIGTERM'));
      });
    } else {
      talker.warning('SIGTERM is not supported on Windows, SIGINT only');
    }

    await stop.future;
    talker.info('Shutdown complete');
    exit(0);
  } catch (e, st) {
    talker.handle(e, st, 'Fatal startup error');
    await server?.close(force: true);
    await dbPool?.close();
    exitCode = 1;
  }
}
