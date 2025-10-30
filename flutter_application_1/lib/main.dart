import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/delivery_provider.dart';
import 'screens/splash_screen.dart'; // Importación CORREGIDA
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DeliveryProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenGo Logistics',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(), // CORREGIDO: Usar SplashScreen
      debugShowCheckedModeBanner: false,
    );
  }
}