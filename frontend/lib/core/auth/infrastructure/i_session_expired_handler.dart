abstract interface class ISessionExpiredHandler {
  /// Emits each time an authenticated request is rejected with 401.
  Stream<void> get sessionExpired;

  void onSessionExpired();
}
