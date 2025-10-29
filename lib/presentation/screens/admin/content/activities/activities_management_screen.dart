import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palestinian_ministry_endowments/presentation/screens/admin/activities/web_activities_management_screen.dart';
import '../../admin/activities/mobile_activities_management_screen.dart';


class ActivitiesManagementScreen extends StatelessWidget {
  const ActivitiesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const WebActivitiesManagementScreen();
    } else {
      return const MobileActivitiesManagementScreen();
    }
  }
}
