class GpsSample {
  const new({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.speedMetersPerSecond,
  });

  final double latitude;
  final double longitude;
  final double? speedMetersPerSecond;
  final DateTime timestamp;
}

abstract interface class Gps {
  Stream<GpsSample> get samples;
}
