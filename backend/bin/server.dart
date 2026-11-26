import 'package:backend/src/server.dart';

/// Production entrypoint, compiled to a native binary in `backend/Dockerfile`.
/// Reads config from process environment variables (see `.env.example`).
Future<void> main() => runServer();
