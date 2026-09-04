class DetectedEvent {
  const DetectedEvent({
    required this.eventId,
    required this.eventType,
    required this.occurredAt,
    required this.detectorName,
    required this.detectorVersion,
  });

  final String eventId;
  final String eventType;
  final DateTime occurredAt;
  final String detectorName;
  final String detectorVersion;
}
