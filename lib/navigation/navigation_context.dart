class NavigationContext {
  const new({
    this.speedAtEvent,
    this.averageSpeedPrevious5Seconds,
    this.maximumSpeedPrevious10Seconds,
    this.isMoving,
  });

  final double? speedAtEvent;
  final double? averageSpeedPrevious5Seconds;
  final double? maximumSpeedPrevious10Seconds;
  final bool? isMoving;
}
