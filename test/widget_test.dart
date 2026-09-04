import 'package:flutter_test/flutter_test.dart';

import 'package:securedelivery_mobile/app/app.dart';

void main() {
  testWidgets('SecureDelivery app renders', (tester) async {
    await tester.pumpWidget(const SecureDeliveryApp());

    expect(find.text('SecureDelivery'), findsOneWidget);
  });
}
