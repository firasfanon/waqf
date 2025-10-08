import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'mobile_news_screen.dart';
import 'web_news_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const WebNewsScreen();
    } else {
      return const MobileNewsScreen();
    }
  }
}