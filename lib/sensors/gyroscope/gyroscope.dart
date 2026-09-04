class GyroscopeSample {
  const GyroscopeSample({
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

abstract interface class Gyroscope {
  Stream<GyroscopeSample> get samples;
}
