import 'package:backend/src/server.dart';

/// Development entrypoint: `dart run bin/server.dev.dart`.
/// Reads config from the process environment and a local `backend/.env`.
Future<void> main() => runServer();
