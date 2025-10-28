// lib/presentation/screens/public/splash/splash_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palestinian_ministry_endowments/presentation/screens/public/splash/web_splash_screen.dart';
import 'mobile_splash_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const WebSplashScreen();
    } else {
      return const MobileSplashScreen();
    }
  }
}