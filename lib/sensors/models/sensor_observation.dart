class SensorObservation {
  const SensorObservation({
    required this.sensorType,
    required this.observedAt,
    required this.values,
  });

  final String sensorType;
  final DateTime observedAt;
  final Map<String, double> values;
}
