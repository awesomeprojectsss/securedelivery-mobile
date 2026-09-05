abstract interface class ApiClient {
  Future<Object> post(String path, {Object? body});
}
