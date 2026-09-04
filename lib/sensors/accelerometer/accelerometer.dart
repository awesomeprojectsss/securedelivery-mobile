class AccelerometerSample {
  const AccelerometerSample({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  final double x;
  final double y;
  final double z;
  final DateTime timestamp;
}

abstract interface class Accelerometer {
  Stream<AccelerometerSample> get samples;
}
