import 'package:flutter/material.dart';

import 'package:securedelivery_mobile/app/environment/app_environment.dart';

class SecureDeliveryApp extends StatelessWidget {
  const SecureDeliveryApp({required this.environment, super.key});

  final AppEnvironment environment;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecureDelivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: Center(
          child: Text(
            'SecureDelivery\n${environment.name}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
