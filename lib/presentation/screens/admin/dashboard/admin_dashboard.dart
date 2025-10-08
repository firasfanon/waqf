import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'mobile_admin_dashboard.dart';
import 'web_admin_dashboard.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const MobileAdminDashboard();
    } else {
      return const MobileAdminDashboard();
    }
  }
}
