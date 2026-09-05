import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:securedelivery_mobile/sensors/models/sensor_observation.dart';
import 'package:securedelivery_mobile/sensors/sensor.dart';

class FakeSensor implements Sensor {
  final StreamController<SensorObservation> _controller =
      StreamController<SensorObservation>.broadcast();

  bool started = false;

  @override
  String get type => 'fake';

  @override
  Stream<SensorObservation> observe() => _controller.stream;

  @override
  Future<void> start() async {
    started = true;
  }

  @override
  Future<void> stop() async {
    started = false;
  }

  Future<void> dispose() => _controller.close();
}

void main() {
  group('Sensor', () {
    late FakeSensor sensor;

    setUp(() {
      sensor = FakeSensor();
    });

    tearDown(() async {
      await sensor.dispose();
    });

    test('exposes its sensor type', () {
      expect(sensor.type, 'fake');
    });

    test('starts and stops the sensor', () async {
      await sensor.start();

      expect(sensor.started, isTrue);

      await sensor.stop();

      expect(sensor.started, isFalse);
    });

    test('exposes sensor observations through a stream', () async {
      final observation = SensorObservation(
        sensorType: 'fake',
        observedAt: DateTime.utc(2026, 1, 1, 12),
        values: const {'value': 1.0},
      );

      final future = expectLater(sensor.observe(), emits(observation));

      sensor._controller.add(observation);

      await future;
    });
  });
}
