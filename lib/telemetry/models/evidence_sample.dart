class EvidenceSample {
  const new({required this.timestamp, required this.values});

  final DateTime timestamp;
  final Map<String, double> values;
}
