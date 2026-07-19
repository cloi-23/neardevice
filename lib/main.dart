import 'package:flutter/material.dart';

import 'features/nearby/screens/nearby_dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const FindMyLittleBrotherApp());
}

class FindMyLittleBrotherApp extends StatelessWidget {
  const FindMyLittleBrotherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Find Nearby Devices",

      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),

      home: const NearbyDashboard(),
    );
  }
}
