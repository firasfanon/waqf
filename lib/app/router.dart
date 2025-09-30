import 'package:flutter/material.dart';
import '../presentation/screens/public/splash_screen.dart';
import '../presentation/screens/public/home_screen.dart';
import '../presentation/screens/public/news_screen.dart';
import '../presentation/screens/public/news_detail_screen.dart';
import '../presentation/screens/public/announcements_screen.dart';
import '../presentation/screens/public/activities_screen.dart';
import '../presentation/screens/public/services_screen.dart' hide EServicesScreen;
import '../presentation/screens/public/eservices_screen.dart';
import '../presentation/screens/public/mosques_screen.dart';
import '../presentation/screens/public/projects_screen.dart';
import '../presentation/screens/public/about_screen.dart';
import '../presentation/screens/public/minister_screen.dart';
import '../presentation/screens/public/vision_mission_screen.dart';
import '../presentation/screens/public/structure_screen.dart';
import '../presentation/screens/public/former_ministers_screen.dart';
import '../presentation/screens/public/contact_screen.dart';
import '../presentation/screens/public/search_screen.dart';
import '../presentation/screens/admin/login_screen.dart' hide SizedBox;
import '../presentation/screens/admin/admin_dashboard.dart';
import '../presentation/screens/admin/waqf_lands_screen.dart';
import '../presentation/screens/admin/cases_screen.dart';
import '../presentation/screens/admin/documents_screen.dart';
import '../data/models/news_article.dart';

class AppRouter {
  // Public Routes
  static const String splash = '/';
  static const String home = '/home';
  static const String news = '/news';
  static const String newsDetail = '/news/detail';
  static const String announcements = '/announcements';
  static const String activities = '/activities';
  static const String services = '/services';
  static const String eservices = '/eservices';
  static const String mosques = '/mosques';
  static const String projects = '/projects';
  static const String about = '/about';
  static const String minister = '/minister';
  static const String visionMission = '/vision-mission';
  static const String structure = '/structure';
  static const String formerMinisters = '/former-ministers';
  static const String contact = '/contact';
  static const String search = '/search';

  // Admin Routes
  static const String adminLogin = '/admin/login';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminWaqfLands = '/admin/waqf-lands';
  static const String adminCases = '/admin/cases';
  static const String adminDocuments = '/admin/documents';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
    // Public Routes
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case news:
        return MaterialPageRoute(
          builder: (_) => const NewsScreen(),
          settings: settings,
        );

      case newsDetail:
        final article = settings.arguments as NewsArticle?;
        return MaterialPageRoute(
          builder: (_) => NewsDetailScreen(article: article),
          settings: settings,
        );

      case announcements:
        return MaterialPageRoute(
          builder: (_) => const AnnouncementsScreen(),
          settings: settings,
        );

      case activities:
        return MaterialPageRoute(
          builder: (_) => const ActivitiesScreen(),
          settings: settings,
        );

      case services:
        return MaterialPageRoute(
          builder: (_) => const ServicesScreen(),
          settings: settings,
        );

      case eservices:
        return MaterialPageRoute(
          builder: (_) => const EServicesScreen(),
          settings: settings,
        );

      case mosques:
        return MaterialPageRoute(
          builder: (_) => const MosquesScreen(),
          settings: settings,
        );

      case projects:
        return MaterialPageRoute(
          builder: (_) => const ProjectsScreen(),
          settings: settings,
        );

      case about:
        return MaterialPageRoute(
          builder: (_) => const AboutScreen(),
          settings: settings,
        );

      case minister:
        return MaterialPageRoute(
          builder: (_) => const MinisterScreen(),
          settings: settings,
        );

      case visionMission:
        return MaterialPageRoute(
          builder: (_) => const VisionMissionScreen(),
          settings: settings,
        );

      case structure:
        return MaterialPageRoute(
          builder: (_) => const StructureScreen(),
          settings: settings,
        );

      case formerMinisters:
        return MaterialPageRoute(
          builder: (_) => const FormerMinistersScreen(),
          settings: settings,
        );

      case contact:
        return MaterialPageRoute(
          builder: (_) => const ContactScreen(),
          settings: settings,
        );

      case search:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
          settings: settings,
        );

    // Admin Routes
      case adminLogin:
        return MaterialPageRoute(
          builder: (_) => const AdminLoginScreen(),
          settings: settings,
        );

      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const AdminDashboardScreen(),
          settings: settings,
        );

      case adminWaqfLands:
        return MaterialPageRoute(
          builder: (_) => const WaqfLandsScreen(),
          settings: settings,
        );

      case adminCases:
        return MaterialPageRoute(
          builder: (_) => const CasesScreen(),
          settings: settings,
        );

      case adminDocuments:
        return MaterialPageRoute(
          builder: (_) => const DocumentsScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundScreen(),
          settings: settings,
        );
    }
  }

  // Navigation helpers
  static Future<T?> push<T extends Object?>(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushAndClearStack<T extends Object?>(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
          (route) => false,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  // Route validation
  static bool isPublicRoute(String routeName) {
    const publicRoutes = [
      splash, home, news, newsDetail, announcements, activities,
      services, eservices, mosques, projects, about, minister,
      visionMission, structure, formerMinisters, contact, search,
    ];
    return publicRoutes.contains(routeName);
  }

  static bool isAdminRoute(String routeName) {
    return routeName.startsWith('/admin');
  }

  static bool requiresAuth(String routeName) {
    return isAdminRoute(routeName) && routeName != adminLogin;
  }
}

// 404 Not Found Screen
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة غير موجودة'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              '404',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'الصفحة غير موجودة',
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => AppRouter.pushReplacement(context, AppRouter.home),
              child: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    );
  }
}

// Route animations
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final AxisDirection direction;

  SlidePageRoute({
    required this.child,
    this.direction = AxisDirection.left,
    super.settings,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin;
      switch (direction) {
        case AxisDirection.up:
          begin = const Offset(0.0, 1.0);
          break;
        case AxisDirection.down:
          begin = const Offset(0.0, -1.0);
          break;
        case AxisDirection.right:
          begin = const Offset(-1.0, 0.0);
          break;
        case AxisDirection.left:
          begin = const Offset(1.0, 0.0);
          break;
      }

      const end = Offset.zero;
      const curve = Curves.easeInOut;
      final tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  FadePageRoute({
    required this.child,
    super.settings,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  ScalePageRoute({
    required this.child,
    super.settings,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return ScaleTransition(
        scale: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}