import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/announcement.dart';
import '../../widgets/common/custom_app_bar.dart';

class AnnouncementsScreen extends ConsumerStatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  ConsumerState<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends ConsumerState<AnnouncementsScreen> {
  Priority? _selectedPriority;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'الإعلانات الرسمية',
        showSearchButton: true,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            color: Colors.grey[50],
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: 'البحث في الإعلانات...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                // Priority Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPriorityChip('الكل', null),
                      ...Priority.values.map((priority) {
                        return _buildPriorityChip(priority.displayName,
                            priority);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Announcements List
          Expanded(
            child: _buildAnnouncementsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(String label, Priority? priority) {
    final isSelected = _selectedPriority == priority;

    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedPriority = selected ? priority : null;
          });
        },
        selectedColor: AppConstants.islamicGreen.withValues(alpha:0.2),
        checkmarkColor: AppConstants.islamicGreen,
        side: BorderSide(
          color: isSelected ? AppConstants.islamicGreen : Colors.grey[300]!,
        ),
      ),
    );
  }

  Widget _buildAnnouncementsList() {
    final announcements = _getFilteredAnnouncements();

    if (announcements.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh announcements
      },
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 300),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildAnnouncementCard(announcements[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _getPriorityColor(announcement.priority).withValues(alpha:0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with priority badge
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: _getPriorityColor(announcement.priority).withValues(alpha:0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.radiusM),
                topRight: Radius.circular(AppConstants.radiusM),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(announcement.priority),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getPriorityIcon(announcement.priority),
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        announcement.priority.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Date
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppDateUtils.getTimeAgo(announcement.createdAt),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  announcement.title,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppConstants.onSurface,
                  ),
                ),

                const SizedBox(height: 8),

                // Content
                Text(
                  announcement.content,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 12),

                // Footer
                Row(
                  children: [
                    // Target Audience
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppConstants.islamicGreen.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.group,
                            size: 14,
                            color: AppConstants.islamicGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            announcement.targetAudience,
                            style: const TextStyle(
                              color: AppConstants.islamicGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Valid Until
                    if (announcement.validUntil != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: Colors.orange[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'صالح حتى ${AppDateUtils.formatArabicDate(
                                announcement.validUntil!)}',
                            style: TextStyle(
                              color: Colors.orange[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.campaign_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد إعلانات',
            style: Theme
                .of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على إعلانات تطابق البحث',
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  List<Announcement> _getFilteredAnnouncements() {
    // Sample announcements data
    final announcements = [
      Announcement(
        id: 1,
        title: 'إعلان مهم حول مواعيد صلاة الجمعة',
        content: 'يعلن قسم المساجد في وزارة الأوقاف عن تغيير موعد صلاة الجمعة في جميع مساجد المحافظة لتصبح الساعة 12:30 ظهراً بدلاً من 12:00 ظهراً، وذلك اعتباراً من الجمعة القادمة.',
        priority: Priority.high,
        validUntil: DateTime.now().add(const Duration(days: 30)),
        isActive: true,
        targetAudience: 'جميع المصلين',
        createdBy: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Announcement(
        id: 2,
        title: 'دعوة للمشاركة في برنامج تحفيظ القرآن',
        content: 'تدعو الوزارة جميع الراغبين في المشاركة في برنامج تحفيظ القرآن الكريم للتسجيل في المراكز المخصصة لذلك. البرنامج مجاني ومفتوح لجميع الأعمار.',
        priority: Priority.medium,
        validUntil: DateTime.now().add(const Duration(days: 15)),
        isActive: true,
        targetAudience: 'عامة الناس',
        createdBy: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Announcement(
        id: 3,
        title: 'تنبيه عاجل: إغلاق مؤقت لمسجد النور',
        content: 'نعلن عن إغلاق مؤقت لمسجد النور في حي الرمال لإجراء أعمال صيانة ضرورية. سيتم إعادة فتح المسجد خلال أسبوع بإذن الله.',
        priority: Priority.urgent,
        validUntil: DateTime.now().add(const Duration(days: 7)),
        isActive: true,
        targetAudience: 'أهالي حي الرمال',
        createdBy: 1,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];

    return announcements.where((announcement) {
      final matchesSearch = _searchQuery.isEmpty ||
          announcement.title.toLowerCase().contains(
              _searchQuery.toLowerCase()) ||
          announcement.content.toLowerCase().contains(
              _searchQuery.toLowerCase());

      final matchesPriority = _selectedPriority == null ||
          announcement.priority == _selectedPriority;

      return matchesSearch && matchesPriority && announcement.isActive;
    }).toList();
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.blue;
      case Priority.high:
        return Colors.red;
      case Priority.urgent:
        return AppConstants.error;
      case Priority.critical:
        return Colors.purple;
    }
  }

  IconData _getPriorityIcon(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Icons.info_outline;
      case Priority.medium:
        return Icons.warning_amber_outlined;
      case Priority.high:
        return Icons.priority_high;
      case Priority.urgent:
        return Icons.report_problem;
      case Priority.critical:
        return Icons.dangerous;
    }
  }

}