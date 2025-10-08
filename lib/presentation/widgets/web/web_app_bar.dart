// lib/presentation/widgets/web/web_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../app/router.dart';
import '../../providers/auth_provider.dart';

/// Web-optimized AppBar
/// Features: Horizontal navigation links, search, user profile
class WebAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const WebAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          children: [
            // Logo
            _buildLogo(context),

            const SizedBox(width: 60),

            // Navigation Links
            Expanded(child: _buildNavLinks(context)),

            // Search Button
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.pushNamed(context, AppRouter.search),
              tooltip: 'بحث',
            ),

            const SizedBox(width: 20),

            // User Profile or Login
            if (isAuthenticated && currentUser != null)
              _buildUserMenu(context, ref, currentUser)
            else
              _buildLoginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRouter.home),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: AppConstants.islamicGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.mosque, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'وزارة الأوقاف',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppConstants.islamicGreen,
                ),
              ),
              Text(
                'Palestinian Ministry of Endowments',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppConstants.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavLinks(BuildContext context) {
    final links = [
      {'label': 'الرئيسية', 'route': AppRouter.home},
      {'label': 'الأخبار', 'route': AppRouter.news},
      {'label': 'الخدمات', 'route': AppRouter.services},
      {'label': 'المساجد', 'route': AppRouter.mosques},
      {'label': 'عن الوزارة', 'route': AppRouter.about},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: links.map((link) {
        final isActive = _isCurrentRoute(context, link['route'] as String);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, link['route'] as String),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              foregroundColor: isActive ? AppConstants.islamicGreen : AppConstants.textPrimary,
            ),
            child: Text(
              link['label'] as String,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUserMenu(BuildContext context, WidgetRef ref, dynamic user) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppConstants.borderLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppConstants.islamicGreen,
              child: Text(
                user.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'dashboard',
          child: Row(
            children: const [
              Icon(Icons.dashboard, size: 20),
              SizedBox(width: 12),
              Text('لوحة التحكم'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: const [
              Icon(Icons.person, size: 20),
              SizedBox(width: 12),
              Text('الملف الشخصي'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: const [
              Icon(Icons.logout, size: 20, color: AppConstants.error),
              SizedBox(width: 12),
              Text('تسجيل الخروج', style: TextStyle(color: AppConstants.error)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'dashboard':
            Navigator.pushNamed(context, AppRouter.adminDashboard);
            break;
          case 'profile':
            Navigator.pushNamed(context, AppRouter.adminProfile);
            break;
          case 'logout':
            ref.read(authStateProvider.notifier).logout();
            break;
        }
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.pushNamed(context, AppRouter.adminLogin),
      icon: const Icon(Icons.login),
      label: const Text('تسجيل الدخول'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.islamicGreen,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  bool _isCurrentRoute(BuildContext context, String route) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return currentRoute == route;
  }
}