import 'package:flutter_test/flutter_test.dart';

import 'package:securedelivery_mobile/sensors/models/sensor_observation.dart';

void main() {
  test('creates a sensor observation with its values', () {
    final observedAt = DateTime.utc(2026, 1, 1, 12);

    final observation = SensorObservation(
      sensorType: 'accelerometer',
      observedAt: observedAt,
      values: const {'x': 1.0, 'y': 2.0, 'z': 3.0},
    );

    expect(observation.sensorType, 'accelerometer');
    expect(observation.observedAt, observedAt);
    expect(observation.values['x'], 1.0);
    expect(observation.values['y'], 2.0);
    expect(observation.values['z'], 3.0);
  });
}
