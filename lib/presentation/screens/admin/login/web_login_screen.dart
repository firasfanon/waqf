// lib/presentation/screens/admin/web_login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/forms/custom_text_field.dart';

/// Web-optimized Admin Login Screen
/// Features: Centered card, split layout with branding
class WebLoginScreen extends ConsumerStatefulWidget {
  const WebLoginScreen({super.key});

  @override
  ConsumerState<WebLoginScreen> createState() => _WebLoginScreenState();
}

class _WebLoginScreenState extends ConsumerState<WebLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authStateProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.adminDashboard);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppConstants.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Side - Branding (40%)
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppConstants.islamicGradient,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.mosque,
                          size: 70,
                          color: AppConstants.islamicGreen,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'وزارة الأوقاف والشؤون الدينية',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لوحة التحكم الإدارية',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Right Side - Login Form (60%)
          Expanded(
            flex: 6,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(60),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'تسجيل الدخول',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppConstants.islamicGreen,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'مرحباً بك في لوحة التحكم',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppConstants.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Login Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _emailController,
                              label: 'البريد الإلكتروني',
                              hint: 'أدخل بريدك الإلكتروني',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'البريد الإلكتروني مطلوب';
                                }
                                if (!value.contains('@')) {
                                  return 'البريد الإلكتروني غير صحيح';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            PasswordTextField(
                              controller: _passwordController,
                              label: 'كلمة المرور',
                              hint: 'أدخل كلمة المرور',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'كلمة المرور مطلوبة';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Remember Me & Forgot Password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() => _rememberMe = value ?? false);
                                      },
                                    ),
                                    const Text('تذكرني'),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    // TODO: Forgot password
                                  },
                                  child: const Text('نسيت كلمة المرور؟'),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Login Button
                            SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConstants.islamicGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Back to Home
                      Center(
                        child: TextButton.icon(
                          onPressed: () => Navigator.pushNamed(context, AppRouter.home),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('العودة للصفحة الرئيسية'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}