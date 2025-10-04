import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';
import '../../../app/router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showSearchButton = false,
    this.showNotificationButton = false,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = true,
    this.bottom,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  final String title;
  final bool showBackButton;
  final bool showSearchButton;
  final bool showNotificationButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double? elevation;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.titleLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: backgroundColor ?? AppColors.islamicGreen,
      elevation: elevation ?? 2,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ?? (showBackButton ? _buildBackButton(context) : null),
      actions: _buildActions(context),
      bottom: bottom,
      iconTheme: const IconThemeData(color: Colors.white),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  Widget? _buildBackButton(BuildContext context) {
    if (!AppRouter.canPop(context) && !showBackButton) {
      return null;
    }

    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () => AppRouter.pop(context),
      tooltip: 'رجوع',
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actionsList = <Widget>[];

    // Add search button
    if (showSearchButton) {
      actionsList.add(
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => AppRouter.push(context, AppRouter.search),
          tooltip: 'بحث',
        ),
      );
    }

    // Add notification button
    if (showNotificationButton) {
      actionsList.add(
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              // Notification badge
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () => _showNotifications(context),
          tooltip: 'الإشعارات',
        ),
      );
    }

    // Add custom actions
    if (actions != null) {
      actionsList.addAll(actions!);
    }

    return actionsList;
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusL),
        ),
      ),
      builder: (context) => const NotificationBottomSheet(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );
}

class NotificationBottomSheet extends StatelessWidget {
  const NotificationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            'الإشعارات',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Notifications list
          _buildNotificationItem(
            title: 'إعلان جديد',
            message: 'تم نشر إعلان مهم حول مواعيد صلاة الجمعة',
            time: 'منذ ساعة',
            isRead: false,
          ),

          _buildNotificationItem(
            title: 'خبر جديد',
            message: 'افتتاح مسجد جديد في مدينة رام الله',
            time: 'منذ ساعتين',
            isRead: true,
          ),

          _buildNotificationItem(
            title: 'تذكير',
            message: 'موعد المحاضرة غداً في تمام الساعة الثالثة',
            time: 'منذ يوم',
            isRead: true,
          ),

          const SizedBox(height: 16),

          // See all button
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to notifications screen
              },
              child: const Text('عرض جميع الإشعارات'),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    required bool isRead,
  }) {
    return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppConstants.paddingM),
        decoration: BoxDecoration(
          color: isRead ? Colors.grey[50] : AppColors.islamicGreen.withOpacity(
              0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: isRead ? Colors.grey[200]! : AppColors.islamicGreen
                .withOpacity(0.3),
          ),
        ),
        child: Row(
            children: [
              // Notification icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.islamicGreen.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications,
                  color: AppColors.islamicGreen,
                  size: 20,
                ),
              )
            ]
        )
    );
  }
}