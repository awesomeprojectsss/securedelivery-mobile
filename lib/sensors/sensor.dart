import 'dart:async';

import 'package:securedelivery_mobile/sensors/models/sensor_observation.dart';

abstract interface class Sensor {
  String get type;

  Stream<SensorObservation> observe();

  Future<void> start();

  Future<void> stop();
}
