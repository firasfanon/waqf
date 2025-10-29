import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palestinian_ministry_endowments/presentation/screens/admin/waqf_lands/mobile_waqf_lands_screen.dart';
import 'package:palestinian_ministry_endowments/presentation/screens/admin/waqf_lands/web_waqf_lands_screen.dart';


class WaqfLandsScreen extends StatelessWidget {
  const WaqfLandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const WebWaqfLandsScreen();
    } else {
      return const MobileWaqfLandsScreen();
    }
  }
}
