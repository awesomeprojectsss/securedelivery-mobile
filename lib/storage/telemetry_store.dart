abstract interface class TelemetryStore {
  Future<void> save(Object telemetry);

  Future<List<Object>> getPending();

  Future<void> acknowledge(String batchId);
}
