import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../app/router.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/home/hero_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Web-optimized Splash Screen matching web theme
class WebSplashScreen extends ConsumerStatefulWidget {
  const WebSplashScreen({super.key});

  @override
  ConsumerState<WebSplashScreen> createState() => _WebSplashScreenState();
}

class _WebSplashScreenState extends ConsumerState<WebSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitializationSequence();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

  void _startInitializationSequence() async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // Wait minimum 2 seconds for branding
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    // Preload hero slides and cache images
    try {
      final slidesAsync = await ref.read(heroSlidesProvider.future);

      if (mounted && slidesAsync.isNotEmpty) {
        // Precache all hero slide images
        await Future.wait(
          slidesAsync.map((slide) =>
            precacheImage(
              CachedNetworkImageProvider(slide.imageUrl),
              context,
            )
          ),
        );
      }
    } catch (e) {
      // Continue even if preloading fails
      debugPrint('Error preloading hero slides: $e');
    }

    if (!mounted) return;

    // Check authentication
    final isAuthenticated = ref.read(isAuthenticatedProvider);

    if (isAuthenticated) {
      AppRouter.pushAndClearStack(context, AppRouter.adminDashboard);
    } else {
      AppRouter.pushAndClearStack(context, AppRouter.home);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo container matching web app bar style
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.islamicGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.mosque,
                  size: 50,
                  color: AppColors.islamicGreen,
                ),
              ),

              const SizedBox(height: 32),

              // Ministry name in Arabic
              Text(
                'وزارة الأوقاف والشؤون الدينية',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.islamicGreen,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // English name
              Text(
                'Palestinian Ministry of Endowments',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontFamily: AppTextStyles.englishFont,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 60),

              // Loading indicator - matching app theme
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.islamicGreen,
                  ),
                  strokeWidth: 3,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'جاري التحميل...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
