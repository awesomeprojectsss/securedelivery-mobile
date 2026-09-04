import 'monitoring_session.dart';
import 'monitoring_state.dart';

class MonitoringCoordinator {
  MonitoringState state = MonitoringState.off;

  MonitoringSession? currentSession;

  Future<void> start() async {
    // Generate and persist monitoringSessionId before acquisition starts.
  }

  Future<void> stop() async {
    // Persist finishedAt and synchronize the session lifecycle.
  }
}
