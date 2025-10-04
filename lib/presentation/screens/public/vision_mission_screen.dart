import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/common/custom_app_bar.dart';

class VisionMissionScreen extends StatelessWidget {
  const VisionMissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'الرؤية والرسالة'),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        children: [
          _buildVisionCard(),
          const SizedBox(height: 24),
          _buildMissionCard(),
          const SizedBox(height: 24),
          _buildValuesCard(),
          const SizedBox(height: 24),
          _buildGoalsCard(),
        ],
      ),
    );
  }

  Widget _buildVisionCard() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        decoration: BoxDecoration(
          gradient: AppColors.islamicGradient,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.visibility, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Text(
                  'رؤيتنا',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'أن نكون المرجع الأول في خدمة المساجد والأوقاف الإسلامية في فلسطين، ونموذجاً رائداً في الإدارة الحديثة للمؤسسات الدينية.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flag, color: AppColors.islamicGreen, size: 32),
                const SizedBox(width: 12),
                Text(
                  'رسالتنا',
                  style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'العمل على خدمة المساجد والأوقاف الإسلامية وإدارتها بكفاءة وشفافية، والمحافظة على المقدسات الإسلامية، ونشر الوعي الديني الصحيح، وتقديم الخدمات الدينية للمواطنين.',
              style: AppTextStyles.bodyLarge.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildValuesCard() {
    final values = [
      {'title': 'الشفافية', 'icon': Icons.visibility, 'description': 'العمل بوضوح ومصداقية'},
      {'title': 'الإتقان', 'icon': Icons.star, 'description': 'تقديم خدمات بجودة عالية'},
      {'title': 'المسؤولية', 'icon': Icons.assignment, 'description': 'الالتزام بالواجبات'},
      {'title': 'الابتكار', 'icon': Icons.lightbulb, 'description': 'التطوير المستمر'},
      {'title': 'التعاون', 'icon': Icons.handshake, 'description': 'العمل بروح الفريق'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite, color: AppColors.islamicGreen, size: 32),
                const SizedBox(width: 12),
                Text(
                  'قيمنا',
                  style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...values.map((value) => _buildValueItem(value)),
          ],
        ),
      ),
    );
  }

  Widget _buildValueItem(Map<String, dynamic> value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.islamicGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(value['icon'] as IconData, color: AppColors.islamicGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value['title'], style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value['description'], style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsCard() {
    final goals = [
      'المحافظة على المقدسات الإسلامية والأوقاف',
      'تطوير وتحسين خدمات المساجد',
      'تأهيل وتدريب الأئمة والخطباء',
      'نشر الوعي الديني الصحيح',
      'تحديث أنظمة إدارة الأوقاف',
      'تعزيز دور المساجد في المجتمع',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.track_changes, color: AppColors.islamicGreen, size: 32),
                const SizedBox(width: 12),
                Text(
                  'أهدافنا الاستراتيجية',
                  style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...goals.map((goal) => _buildGoalItem(goal)),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(String goal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.islamicGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(goal, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}