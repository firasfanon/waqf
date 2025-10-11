// lib/presentation/screens/public/home_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'mobile_splash_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const MobileSplashScreen();
    } else {
      return const MobileSplashScreen();
    }
  }
}