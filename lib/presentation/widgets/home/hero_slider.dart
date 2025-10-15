import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_constants.dart';
import '../../../app/router.dart';

class HeroSlider extends StatefulWidget {
  const HeroSlider({super.key});

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  final List<SliderItem> _slides = [
    SliderItem(
      title: 'وزير الأوقاف يشارك في المؤتمر الدولي للوقف الإسلامي',
      subtitle: 'مشاركة فلسطينية مميزة في المؤتمر الدولي',
      description: 'شارك معالي وزير الأوقاف والشؤون الدينية في المؤتمر الدولي للوقف الإسلامي الذي عقد في إسطنبول بمشاركة 40 دولة',
      imageUrl: 'https://images.pexels.com/photos/378570/pexels-photo-378570.jpeg?auto=compress&cs=tinysrgb&w=1920',
      ctaText: 'اقرأ المزيد',
    ),
    SliderItem(
      title: 'افتتاح مسجد السلام بعد أعمال الترميم والتطوير',
      subtitle: 'إنجاز جديد في مجال تطوير المساجد',
      description: 'برعاية وزير الأوقاف تم افتتاح مسجد السلام في مدينة نابلس بعد أعمال الترميم والتطوير التي استمرت 6 أشهر',
      imageUrl: 'https://images.pexels.com/photos/8107628/pexels-photo-8107628.jpeg?auto=compress&cs=tinysrgb&w=1920',
      ctaText: 'شاهد التفاصيل',
    ),
    SliderItem(
      title: 'انطلاق فعاليات مسابقة الأقصى لحفظ القرآن الكريم',
      subtitle: 'الدورة الـ15 من المسابقة القرآنية الكبرى',
      description: 'انطلقت فعاليات الدورة الـ15 من مسابقة الأقصى لحفظ القرآن الكريم بمشاركة 500 متسابق من مختلف المحافظات',
      imageUrl: 'https://images.pexels.com/photos/416978/pexels-photo-416978.jpeg?auto=compress&cs=tinysrgb&w=1920',
      ctaText: 'تابع الفعاليات',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel(); // CRITICAL: Cancel timer before dispose
    _autoPlayTimer = null;
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel(); // Cancel existing timer
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // CRITICAL FIX: Check if widget is mounted
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_currentPage < _slides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      // Check both mounted AND hasClients before animating
      if (mounted && _pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _goToSlide(int index) {
    if (!mounted || !_pageController.hasClients) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _previousSlide() {
    if (_currentPage > 0) {
      _goToSlide(_currentPage - 1);
    } else {
      _goToSlide(_slides.length - 1);
    }
  }

  void _nextSlide() {
    if (_currentPage < _slides.length - 1) {
      _goToSlide(_currentPage + 1);
    } else {
      _goToSlide(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.6,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              if (mounted) {
                setState(() {
                  _currentPage = index;
                });
              }
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return _buildSlide(_slides[index], index);
            },
          ),

          // Slider Indicators
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                    (index) => GestureDetector(
                  onTap: () => _goToSlide(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 40 : 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.goldenYellow
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: _currentPage == index
                          ? [
                        BoxShadow(
                          color: AppColors.goldenYellow.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Left Arrow
          Positioned(
            left: 32,
            top: 0,
            bottom: 0,
            child: Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _nextSlide,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chevron_right, color: Colors.white, size: 32),
                  ),
                ),
              ),
            ),
          ),

          // Right Arrow
          Positioned(
            right: 32,
            top: 0,
            bottom: 0,
            child: Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _previousSlide,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(SliderItem slide, int index) {
    final isActive = _currentPage == index;

    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: slide.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(gradient: AppConstants.islamicGradient),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(gradient: AppConstants.islamicGradient),
              child: const Center(child: Icon(Icons.image, size: 80, color: Colors.white54)),
            ),
          ),
        ),

        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.sageGreen.withOpacity(0.8),
                  AppConstants.islamicGreen.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Content
        Positioned.fill(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                AnimatedOpacity(
                  opacity: isActive ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    slide.title,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                      shadows: [Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black45)],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Content Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text Section
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedOpacity(
                            opacity: isActive ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 1000),
                            child: Text(
                              slide.subtitle,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 24,
                                color: AppColors.goldenYellow,
                                fontWeight: FontWeight.w600,
                                shadows: const [Shadow(offset: Offset(1, 1), blurRadius: 3, color: Colors.black45)],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          AnimatedOpacity(
                            opacity: isActive ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 1200),
                            child: Text(
                              slide.description,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.6,
                                shadows: const [Shadow(offset: Offset(1, 1), blurRadius: 3, color: Colors.black45)],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),

                    // Buttons Section
                    Expanded(
                      flex: 4,
                      child: AnimatedOpacity(
                        opacity: isActive ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 1400),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, AppRouter.news),
                              icon: const Icon(Icons.article),
                              label: Text(slide.ctaText),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppConstants.islamicGreen,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            OutlinedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, AppRouter.about),
                              icon: const Icon(Icons.info_outline),
                              label: const Text('تعرف علينا'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white, width: 2),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SliderItem {
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final String ctaText;

  SliderItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.ctaText,
  });
}