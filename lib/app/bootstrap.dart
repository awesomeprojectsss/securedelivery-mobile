import 'package:flutter/widgets.dart';

import 'package:securedelivery_mobile/app/app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SecureDeliveryApp());
}
