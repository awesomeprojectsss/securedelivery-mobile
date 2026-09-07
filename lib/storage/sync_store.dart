abstract interface class SyncStore {
  Future<void> save(Object state);

  Future<Object?> load();
}
