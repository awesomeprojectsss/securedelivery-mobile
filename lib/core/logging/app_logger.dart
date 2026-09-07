enum LogLevel { debug, info, warning, error }

class AppLogger {
  const AppLogger();

  void debug(String message) {
    _log(LogLevel.debug, message);
  }

  void info(String message) {
    _log(LogLevel.info, message);
  }

  void warning(String message) {
    _log(LogLevel.warning, message);
  }

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final timestamp = DateTime.now().toUtc().toIso8601String();

    final buffer = StringBuffer()
      ..write('[$timestamp] ')
      ..write('[${level.name.toUpperCase()}] ')
      ..write(message);

    if (error != null) {
      buffer
        ..write(' | error: ')
        ..write(error);
    }

    if (stackTrace != null) {
      buffer
        ..write('\n')
        ..write(stackTrace);
    }

    // Intentionally uses print as the logger's default output sink.
    // ignore: avoid_print
    print(buffer);
  }
}
