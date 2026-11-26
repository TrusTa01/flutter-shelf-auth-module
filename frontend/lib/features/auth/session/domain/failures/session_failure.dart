sealed class SessionFailure {
  const SessionFailure();
}

/// The token is missing, expired or revoked (401).
final class SessionUnauthorizedFailure extends SessionFailure {
  const SessionUnauthorizedFailure();
}

final class SessionNetworkFailure extends SessionFailure {
  const SessionNetworkFailure();
}

final class UnknownSessionFailure extends SessionFailure {
  final String message;
  const UnknownSessionFailure(this.message);
}
