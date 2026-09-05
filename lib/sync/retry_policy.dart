class RetryPolicy {
  bool shouldRetry({required int attempt, required bool isConnected}) {
    return isConnected && attempt < 5;
  }
}
