import 'package:flutter_test/flutter_test.dart';

import 'package:securedelivery_mobile/core/logging/app_logger.dart';

void main() {
  group('AppLogger', () {
    const logger = AppLogger();

    test('logs debug messages', () {
      expect(() => logger.debug('Debug message'), returnsNormally);
    });

    test('logs info messages', () {
      expect(() => logger.info('Info message'), returnsNormally);
    });

    test('logs warning messages', () {
      expect(() => logger.warning('Warning message'), returnsNormally);
    });

    test('logs errors with error and stack trace', () {
      expect(
        () => logger.error(
          'Error message',
          error: Exception('Test exception'),
          stackTrace: StackTrace.current,
        ),
        returnsNormally,
      );
    });
  });
}
