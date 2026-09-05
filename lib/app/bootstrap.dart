import 'package:flutter/widgets.dart';

import 'package:securedelivery_mobile/app/app.dart';
import 'package:securedelivery_mobile/app/environment/environment.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final environment = currentEnvironment;

  runApp(SecureDeliveryApp(environment: environment));
}
