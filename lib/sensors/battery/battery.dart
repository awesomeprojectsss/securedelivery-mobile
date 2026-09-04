class BatteryState {
  const new({required this.level});

  final double level;
}

abstract interface class Battery {
  Stream<BatteryState> get states;
}
