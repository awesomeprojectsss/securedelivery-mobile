class GpsSample {
  const GpsSample({
    required this.latitude,
    required this.longitude,
    this.speedMetersPerSecond,
    required this.timestamp,
  });

  final double latitude;
  final double longitude;
  final double? speedMetersPerSecond;
  final DateTime timestamp;
}

abstract interface class Gps {
  Stream<GpsSample> get samples;
}
