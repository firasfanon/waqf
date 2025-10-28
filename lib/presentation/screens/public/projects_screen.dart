import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/common/custom_app_bar.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _selectedFilter = 'الكل';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'المشاريع'),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(child: _buildProjectsList()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = ['الكل', 'قيد التنفيذ', 'مكتملة', 'مخطط لها'];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) => setState(() => _selectedFilter = filter),
              backgroundColor: Colors.white,
              selectedColor: AppColors.islamicGreen.withValues(alpha:0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.islamicGreen : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectsList() {
    final projects = _getProjects();

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      itemCount: projects.length,
      itemBuilder: (context, index) => _buildProjectCard(projects[index]),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (project['image'] != null)
            Container(
              height: 180,
              decoration: const BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusM)),
              ),
              child: Center(
                child: Icon(Icons.image, size: 64, color: Colors.grey[400]),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        project['title'],
                        style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildStatusBadge(project['status']),
                  ],
                ),
                const SizedBox(height: 12),
                Text(project['description'], style: AppTextStyles.bodyMedium),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(project['location'], style: AppTextStyles.bodySmall),
                    const Spacer(),
                    const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(project['year'], style: AppTextStyles.bodySmall),
                  ],
                ),
                if (project['progress'] != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: project['progress'] / 100,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.islamicGreen),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('${project['progress']}%', style: AppTextStyles.labelMedium),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'قيد التنفيذ':
        color = AppColors.info;
        break;
      case 'مكتملة':
        color = AppColors.success;
        break;
      case 'مخطط لها':
        color = AppColors.warning;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  List<Map<String, dynamic>> _getProjects() {
    return [
      {
        'title': 'ترميم المسجد العمري الكبير',
        'description': 'مشروع ترميم شامل للمسجد العمري الكبير في غزة',
        'location': 'غزة',
        'year': '2024',
        'status': 'قيد التنفيذ',
        'progress': 65,
      },
      {
        'title': 'بناء مركز تعليمي إسلامي',
        'description': 'إنشاء مركز تعليمي متكامل لتدريس العلوم الشرعية',
        'location': 'رام الله',
        'year': '2024',
        'status': 'قيد التنفيذ',
        'progress': 40,
      },
      {
        'title': 'رقمنة سجلات الأوقاف',
        'description': 'مشروع لرقمنة جميع سجلات ووثائق الأوقاف التاريخية',
        'location': 'جميع المحافظات',
        'year': '2023-2024',
        'status': 'قيد التنفيذ',
        'progress': 80,
      },
      {
        'title': 'توسعة مسجد صلاح الدين',
        'description': 'مشروع توسعة وتطوير مسجد صلاح الدين الأيوبي',
        'location': 'نابلس',
        'year': '2023',
        'status': 'مكتملة',
      },
    ];
  }
}