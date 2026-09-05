import 'package:flutter_test/flutter_test.dart';

import 'package:securedelivery_mobile/app/app.dart';
import 'package:securedelivery_mobile/app/environment/development_environment.dart';

void main() {
  testWidgets('SecureDelivery app renders', (tester) async {
    await tester.pumpWidget(
      const SecureDeliveryApp(environment: developmentEnvironment),
    );

    expect(find.text('SecureDelivery\ndevelopment'), findsOneWidget);
  });
}
