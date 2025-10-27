import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../app/router.dart';
import '../../../widgets/common/loading_widget.dart';
import '../../../providers/auth_provider.dart';

/// Web-optimized Splash Screen
/// Shows branded loading experience for web users
class WebSplashScreen extends ConsumerStatefulWidget {
  const WebSplashScreen({super.key});

  @override
  ConsumerState<WebSplashScreen> createState() => _WebSplashScreenState();
}

class _WebSplashScreenState extends ConsumerState<WebSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitializationSequence();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  void _startInitializationSequence() async {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Wait for initialization and animations to complete
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // Check authentication state
    final isAuthenticated = ref.read(isAuthenticatedProvider);

    if (isAuthenticated) {
      // User is logged in ’ Navigate to Admin Dashboard
      AppRouter.pushAndClearStack(context, AppRouter.adminDashboard);
    } else {
      // User not logged in ’ Navigate to Public Home
      AppRouter.pushAndClearStack(context, AppRouter.home);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          gradient: AppColors.islamicGradient,
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with white background circle
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.mosque,
                        size: 70,
                        color: AppColors.islamicGreen,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Ministry name in Arabic
                  Text(
                    'H2'1) 'D#HB'A H'D4$HF 'D/JFJ)',
                    style: AppTextStyles.displaySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        const Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Tagline
                  Text(
                    '/HD) AD37JF',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.goldenYellow,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        const Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // English name
                  Text(
                    'Palestinian Ministry of Endowments',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: AppTextStyles.englishFont,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 70),

                  // Loading indicator with message
                  Column(
                    children: [
                      const SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.goldenYellow,
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        ','1J 'D*-EJD...',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // Version info
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      ''D%5/'1 ${AppConstants.appVersion}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
