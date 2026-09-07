enum ConnectivityState { connected, disconnected, unknown }

abstract interface class Connectivity {
  Stream<ConnectivityState> get states;
}
