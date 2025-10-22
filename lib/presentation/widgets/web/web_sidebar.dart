// lib/presentation/widgets/web/web_sidebar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../app/router.dart';
import '../../providers/auth_provider.dart';

/// Admin Sidebar for Web - FIXED 280px width
/// Persistent navigation for admin dashboard
class WebSidebar extends ConsumerWidget {
  final String? currentRoute;

  const WebSidebar({
    super.key,
    this.currentRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Container(
      width: 280, // FIXED WIDTH - NO ANIMATION
      decoration: BoxDecoration(
        gradient: AppConstants.islamicGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Section
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child:

                  Image.asset( AppConstants.appLogo, height: 60, width: 60),

                ),
                const SizedBox(height: 16),

                const Text(
                  'لوحة التحكم',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'وزارة الأوقاف',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // Navigation Menu
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  _buildSidebarSection('القوائم الرئيسية'),
                  _buildNavItem(
                    context,
                    icon: Icons.dashboard,
                    label: 'لوحة التحكم',
                    route: AppRouter.adminHomeManagement,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.gavel,
                    label: 'القضايا',
                    route: AppRouter.adminCases,
                    badge: 45,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.landscape,
                    label: 'الأراضي الوقفية',
                    route: AppRouter.adminWaqfLands,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.folder,
                    label: 'الوثائق',
                    route: AppRouter.adminDocuments,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.mosque,
                    label: 'المساجد',
                    route: AppRouter.adminMosques,
                  ),
                  const SizedBox(height: 16),
                  _buildSidebarSection('المحتوى'),
                  _buildNavItem(
                    context,
                    icon: Icons.article,
                    label: 'الأخبار',
                    route: AppRouter.adminNews,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.campaign,
                    label: 'الإعلانات',
                    route: AppRouter.adminAnnouncements,
                    badge: 8,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.event,
                    label: 'الفعاليات',
                    route: AppRouter.adminActivities,
                  ),

                  const SizedBox(height: 16),

                  _buildSidebarSection('الإدارة'),
                  _buildNavItem(
                    context,
                    icon: Icons.home_filled,
                    label:'الصفحة الرئيسية',
                    route: AppRouter.adminHomeManagement,
                  ),

                  _buildNavItem(
                    context,
                    icon: Icons.people,
                    label: 'المستخدمون',
                    route: AppRouter.adminUsers,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.settings,
                    label: 'الإعدادات',
                    route: AppRouter.adminSettings,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.bar_chart,
                    label: 'التقارير',
                    route: AppRouter.adminReports,
                  ),


                ],
              ),
            ),
          ),

          // User Profile Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Text(
                    currentUser?.name.substring(0, 1).toUpperCase() ?? 'A',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.islamicGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentUser?.name ?? 'المستخدم',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentUser?.role ?? 'Admin',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 20),
                          SizedBox(width: 12),
                          Text('الملف الشخصي'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings, size: 20),
                          SizedBox(width: 12),
                          Text('الإعدادات'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 20, color: Colors.red),
                          SizedBox(width: 12),
                          Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) => _handleMenuAction(context, ref, value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12, right: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.6),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String route,
        int? badge,
      }) {
    final routeName = ModalRoute.of(context)?.settings.name;
    final isActive = currentRoute == route || routeName == route;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive ? Border.all(color: Colors.white.withOpacity(0.3)) : null,
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.goldenYellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'profile':
        Navigator.pushNamed(context, AppRouter.adminProfile);
        break;
      case 'settings':
        Navigator.pushNamed(context, AppRouter.adminSettings);
        break;
      case 'logout':
        _showLogoutDialog(context, ref);
        break;
    }
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authStateProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}