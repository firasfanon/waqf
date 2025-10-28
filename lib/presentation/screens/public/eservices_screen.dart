import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/common/custom_app_bar.dart';

class EServicesScreen extends StatelessWidget {
  const EServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'الخدمات الإلكترونية'),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        children: [
          _buildServicesGrid(context),
        ],
      ),
    );
  }

  Widget _buildServicesGrid(BuildContext context) {
    final services = [
      {'title': 'ترخيص الخطابة', 'icon': Icons.mic, 'status': 'متاح', 'color': AppColors.success},
      {'title': 'تسجيل مسجد جديد', 'icon': Icons.add_business, 'status': 'متاح', 'color': AppColors.success},
      {'title': 'طلب دعم مالي', 'icon': Icons.request_quote, 'status': 'متاح', 'color': AppColors.success},
      {'title': 'شهادة حسن سيرة وسلوك', 'icon': Icons.verified_user, 'status': 'متاح', 'color': AppColors.success},
      {'title': 'التسجيل في دورات تدريبية', 'icon': Icons.school, 'status': 'متاح', 'color': AppColors.success},
      {'title': 'حجز موعد مع الوزير', 'icon': Icons.calendar_today, 'status': 'قريباً', 'color': AppColors.warning},
      {'title': 'تصاريح الحج والعمرة', 'icon': Icons.flight, 'status': 'قريباً', 'color': AppColors.warning},
      {'title': 'استشارات دينية', 'icon': Icons.help, 'status': 'قريباً', 'color': AppColors.warning},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) => _buildServiceCard(context, services[index]),
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service) {
    final isAvailable = service['status'] == 'متاح';

    return Card(
      child: InkWell(
        onTap: isAvailable ? () => _handleServiceTap(context, service) : null,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: (service['color'] as Color).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Icon(service['icon'] as IconData, size: 32, color: service['color'] as Color),
              ),
              const SizedBox(height: 12),
              Text(
                service['title'] as String,
                style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: (service['color'] as Color).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  service['status'] as String,
                  style: AppTextStyles.labelSmall.copyWith(color: service['color'] as Color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleServiceTap(BuildContext context, Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(service['title'] as String),
        content: const Text('هذه الخدمة متاحة. سيتم توجيهك إلى نموذج الطلب.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('متابعة')),
        ],
      ),
    );
  }
}