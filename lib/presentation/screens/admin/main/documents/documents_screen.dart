import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palestinian_ministry_endowments/presentation/screens/admin/documents/mobile_documents_screen.dart';
import 'package:palestinian_ministry_endowments/presentation/screens/admin/documents/web_documents_screen.dart';


class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const WebDocumentsScreen();
    } else {
      return const MobileDocumentsScreen();
    }
  }
}
