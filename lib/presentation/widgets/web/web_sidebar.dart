// lib/presentation/widgets/web/web_sidebar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../app/router.dart';
import '../../providers/auth_provider.dart';

/// Admin Sidebar for Web
/// Persistent navigation for admin dashboard
class WebSidebar extends ConsumerWidget {
  const WebSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Container(
      width: 260,
      color: AppConstants.onSurface,
      child: Column(
        children: [
          // Logo & User Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppConstants.islamicGradient,
            ),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.mosque,
                    size: 35,
                    color: AppConstants.islamicGreen,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'لوحة التحكم',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (currentUser != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    currentUser.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.dashboard,
                  label: 'الرئيسية',
                  route: AppRouter.adminDashboard,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.landscape,
                  label: 'الأراضي الوقفية',
                  route: AppRouter.adminWaqfLands,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.gavel,
                  label: 'القضايا',
                  route: AppRouter.adminCases,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.description,
                  label: 'الوثائق',
                  route: AppRouter.adminDocuments,
                ),
                const Divider(color: Colors.white24, height: 32),
                _buildNavItem(
                  context,
                  icon: Icons.person,
                  label: 'الملف الشخصي',
                  route: AppRouter.adminProfile,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.settings,
                  label: 'الإعدادات',
                  route: '/admin/settings',
                ),
              ],
            ),
          ),

          // Logout Button
          Container(
            padding: const EdgeInsets.all(16),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.white70),
              title: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                ref.read(authStateProvider.notifier).logout();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hoverColor: Colors.white10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String route,
      }) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isActive = currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppConstants.islamicGreen.withOpacity(0.2) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppConstants.islamicGreen : Colors.white70,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? AppConstants.islamicGreen : Colors.white70,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () => Navigator.pushNamed(context, route),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hoverColor: Colors.white10,
      ),
    );
  }
}