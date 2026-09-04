import 'package:flutter/material.dart';

class SecureDeliveryApp extends StatelessWidget {
  const SecureDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecureDelivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const Scaffold(body: Center(child: Text('SecureDelivery'))),
    );
  }
}
