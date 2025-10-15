// lib/presentation/screens/public/web_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../widgets/home/hero_slider.dart';
import '../../../widgets/web/web_app_bar.dart';
import '../../../widgets/web/web_container.dart';
import '../../../widgets/web/web_footer.dart';


/// Web-optimized Home Screen
/// Features: Horizontal navbar, multi-column layout, footer
class WebHomeScreen extends ConsumerStatefulWidget {
  const WebHomeScreen({super.key});

  @override
  ConsumerState<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends ConsumerState<WebHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildStatsSection(),
            _buildNewsAndSidebar(),
            _buildServicesSection(),
            //_buildContactSection(),
            const WebFooter(),
          ],
        ),
      ),
    );
  }

  // Hero Section (Full Width)
// Replace your old _buildHeroSection() with:
  Widget _buildHeroSection() {
    return const HeroSlider();
  }
  // Stats Section (4 Columns)
  Widget _buildStatsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: WebContainer(
        child: Column(
          children: [
            Text(
              'إحصائيات الوزارة',
              style: Theme
                  .of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstants.islamicGreen,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildStatCard(icon: Icons.mosque,
                    value: '1,250',
                    label: 'مسجد',
                    color: AppConstants.islamicGreen)),
                const SizedBox(width: 20),
                Expanded(child: _buildStatCard(icon: Icons.landscape,
                    value: '850',
                    label: 'أرض وقفية',
                    color: AppConstants.goldenYellow)),
                const SizedBox(width: 20),
                Expanded(child: _buildStatCard(icon: Icons.people,
                    value: '3,200',
                    label: 'إمام وخطيب',
                    color: AppConstants.info)),
                const SizedBox(width: 20),
                Expanded(child: _buildStatCard(icon: Icons.event,
                    value: '450',
                    label: 'نشاط سنوي',
                    color: AppConstants.success)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      {required IconData icon, required String value, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 40),
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: Theme
                .of(context)
                .textTheme
                .displaySmall
                ?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme
                .of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // News + Sidebar Layout (60% / 40%)
  Widget _buildNewsAndSidebar() {
    return Container(
      color: AppColors.surfaceVariant,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: WebContainer(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News Section (60%)
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'آخر الأخبار',
                        style: Theme
                            .of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppConstants.islamicGreen,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRouter.news),
                        child: const Text('عرض جميع الأخبار →'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ..._getSampleNews().map((article) => _buildNewsCard(article)),
                ],
              ),
            ),

            const SizedBox(width: 40),

            // Sidebar (40%)
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  _buildMinisterCard(),
                  const SizedBox(height: 20),
                  _buildAnnouncementsCard(),
                  const SizedBox(height: 20),
                  _buildQuickLinksCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRouter.newsDetail),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
                child: Container(
                  width: 150,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 40),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppConstants.islamicGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        article['category'] as String,
                        style: const TextStyle(
                          color: AppConstants.islamicGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      article['title'] as String,
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article['excerpt'] as String,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        color: AppConstants.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                            Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          article['date'] as String,
                          style: const TextStyle(fontSize: 14, color: Colors
                              .grey),
                        ),
                        const SizedBox(width: 20),
                        const Icon(
                            Icons.visibility, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${article['views']}',
                          style: const TextStyle(fontSize: 14, color: Colors
                              .grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMinisterCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: AppConstants.islamicGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppConstants.radiusL),
                topRight: Radius.circular(AppConstants.radiusL),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  'كلمة معالي الوزير',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppConstants.islamicGreen.withOpacity(0.1),
                  child: const Icon(
                      Icons.person, size: 50, color: AppConstants.islamicGreen),
                ),
                const SizedBox(height: 16),
                Text(
                  'د. محمود الهباش',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppConstants.islamicGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'وزير الأوقاف والشؤون الدينية',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: AppConstants.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'نرحب بكم في موقع وزارة الأوقاف والشؤون الدينية الفلسطينية، حيث نعمل على خدمة ديننا الحنيف ومجتمعنا الفلسطيني.',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRouter.minister),
                  child: const Text('اقرأ المزيد'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.campaign, color: AppConstants.islamicGreen),
                const SizedBox(width: 12),
                Text(
                  'إعلانات هامة',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildAnnouncementItem(
            title: 'تغيير موعد صلاة الجمعة',
            priority: 'عاجل',
            color: AppConstants.error,
          ),
          _buildAnnouncementItem(
            title: 'دورة تدريبية لأئمة المساجد',
            priority: 'هام',
            color: AppConstants.warning,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRouter.announcements),
                child: const Text('عرض جميع الإعلانات'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementItem(
      {required String title, required String priority, required Color color}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          priority,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  Widget _buildQuickLinksCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.link, color: AppConstants.islamicGreen),
                const SizedBox(width: 12),
                Text(
                  'روابط سريعة',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildQuickLinkItem(icon: Icons.mosque,
              title: 'دليل المساجد',
              route: AppRouter.mosques),
          _buildQuickLinkItem(icon: Icons.computer,
              title: 'الخدمات الإلكترونية',
              route: AppRouter.eservices),
          _buildQuickLinkItem(icon: Icons.construction,
              title: 'المشاريع',
              route: AppRouter.projects),
          _buildQuickLinkItem(icon: Icons.contact_phone,
              title: 'اتصل بنا',
              route: AppRouter.contact),
        ],
      ),
    );
  }

  Widget _buildQuickLinkItem(
      {required IconData icon, required String title, required String route}) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppConstants.islamicGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppConstants.islamicGreen, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }

  // Services Section (Grid)
  Widget _buildServicesSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: WebContainer(
        child: Column(
          children: [
            Text(
              'خدماتنا',
              style: Theme
                  .of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstants.islamicGreen,
              ),
            ),
            const SizedBox(height: 40),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.2,
              children: [
                _buildServiceCard(icon: Icons.mosque,
                    title: 'دليل المساجد',
                    route: AppRouter.mosques),
                _buildServiceCard(icon: Icons.computer,
                    title: 'الخدمات الإلكترونية',
                    route: AppRouter.eservices),
                _buildServiceCard(icon: Icons.event,
                    title: 'الأنشطة والفعاليات',
                    route: AppRouter.activities),
                _buildServiceCard(icon: Icons.construction,
                    title: 'المشاريع',
                    route: AppRouter.projects),
                _buildServiceCard(icon: Icons.article,
                    title: 'الأخبار',
                    route: AppRouter.news),
                _buildServiceCard(icon: Icons.campaign,
                    title: 'الإعلانات',
                    route: AppRouter.announcements),
                _buildServiceCard(icon: Icons.info,
                    title: 'عن الوزارة',
                    route: AppRouter.about),
                _buildServiceCard(icon: Icons.contact_phone,
                    title: 'اتصل بنا',
                    route: AppRouter.contact),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
      {required IconData icon, required String title, required String route}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppConstants.islamicGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppConstants.islamicGreen, size: 35),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
/*
  // Contact Section
  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: const BoxDecoration(
        gradient: AppConstants.islamicGradient,
      ),
      child: WebContainer(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تواصل معنا',
                    style: Theme
                        .of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildContactInfo(
                    icon: Icons.location_on,
                    title: 'العنوان',
                    content: 'رام الله - فلسطين\nشارع الإرسال - مجمع الوزارات',
                  ),
                  const SizedBox(height: 20),
                  _buildContactInfo(
                    icon: Icons.phone,
                    title: 'الهاتف',
                    content: '+970-2-2406340',
                  ),
                  const SizedBox(height: 20),
                  _buildContactInfo(
                    icon: Icons.email,
                    title: 'البريد الإلكتروني',
                    content: 'info@awqaf.ps',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 60),
            Expanded(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أرسل رسالة',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppConstants.islamicGreen,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'الاسم',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'الرسالة',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.islamicGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('إرسال',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
*/
  Widget _buildContactInfo(
      {required IconData icon, required String title, required String content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getSampleNews() {
    return [
      {
        'title': 'افتتاح مسجد جديد في مدينة رام الله',
        'excerpt': 'تم افتتاح مسجد جديد في حي الطيرة برام الله بحضور معالي الوزير وجمع من المواطنين',
        'category': 'مساجد',
        'date': 'منذ ساعتين',
        'views': 150,
      },
      {
        'title': 'ندوة حول الوسطية في الإسلام',
        'excerpt': 'تنظم الوزارة ندوة علمية حول موضوع الوسطية في الإسلام بمشاركة علماء من مختلف البلدان',
        'category': 'فعاليات',
        'date': 'منذ 5 ساعات',
        'views': 89,
      },
      {
        'title': 'دورة تدريبية لأئمة المساجد حول الخطابة',
        'excerpt': 'تنطلق غداً دورة تدريبية متخصصة لأئمة المساجد حول فن الخطابة والإلقاء',
        'category': 'تعليم',
        'date': 'منذ يوم',
        'views': 67,

      }
    ];
  }
}