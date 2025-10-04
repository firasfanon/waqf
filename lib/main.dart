// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_constants.dart';
import 'core/services/storage_service.dart';
import 'app/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await _initializeServices();

  // Configure system UI
  _configureSystemUI();

  // Run app
  runApp(
    const ProviderScope(
      child: PalestinianMinistryApp(),
    ),
  );
}

Future<void> _initializeServices() async {
  // 1. Initialize Storage Service (Must be first!)
  await StorageService.instance.init();

  // 2. Initialize Supabase
  try {
    await Supabase.initialize(
      url: AppConstants.baseUrl,
      anonKey: AppConstants.apiKey,
    );
  } catch (e) {
    debugPrint('Supabase initialization failed: $e');
  }

  // TODO: Add other services when needed (notifications, etc.)
}

void _configureSystemUI() {
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

class PalestinianMinistryApp extends ConsumerWidget {
  const PalestinianMinistryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Localization
      locale: const Locale('ar', 'PS'),
      supportedLocales: const [
        Locale('ar', 'PS'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Theme configuration
      theme: _buildTheme(),

      // Routing
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.splash,

      // Builder for RTL support
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            child: child ?? const SizedBox(),
          ),
        );
      },
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.islamicGreen,
        brightness: Brightness.light,
      ),
      primaryColor: AppColors.islamicGreen,
      scaffoldBackgroundColor: AppColors.background,
      useMaterial3: true,
    );
  }
}