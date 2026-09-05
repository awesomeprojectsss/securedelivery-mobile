abstract interface class EventStore {
  Future<void> save(Object event);

  Future<List<Object>> getPending();

  Future<void> acknowledge(String eventId);
}
