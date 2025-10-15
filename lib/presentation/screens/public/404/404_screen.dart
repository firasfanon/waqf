import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palestinian_ministry_endowments/presentation/screens/public/404/mobile_404_screen.dart';
import 'package:palestinian_ministry_endowments/presentation/screens/public/404/web_404_screen.dart';


class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const WebNotFoundScreen ();
    } else {
      return const MobileNotFoundScreen();
    }
  }
}
