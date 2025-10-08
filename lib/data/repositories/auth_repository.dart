// lib/data/repositories/auth_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/admin_user.dart';
import '../services/supabase_service.dart';
import '../../core/services/storage_service.dart';

class AuthRepository {
  final SupabaseService _supabaseService;

  AuthRepository(this._supabaseService);

  // ============================================
  // AUTHENTICATION METHODS
  // ============================================

  /// Login with email and password
  /// Returns AdminUser on success
  /// Throws AuthException on failure
// lib/data/repositories/auth_repository.dart

  Future<AdminUser> login(String email, String password) async {
    try {
      // ✅ LOG: Starting login
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🔐 LOGIN ATTEMPT');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📧 Email: $email');
      print('🔑 Password length: ${password.length}');
      print('⏰ Time: ${DateTime.now()}');
      print('');

      // 1. Authenticate with Supabase Auth
      print('📡 Calling Supabase Auth...');
      final response = await _supabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('');
      print('✅ Supabase Auth Response:');
      print('   User ID: ${response.user?.id}');
      print('   Email: ${response.user?.email}');
      print('   Session exists: ${response.session != null}');
      if (response.session?.accessToken != null) {
        print('   Access token: ${response.session!.accessToken.substring(0, 20)}...');
      }
      print('');

      // 2. Check if login was successful
      if (response.user == null) {
        print('❌ ERROR: No user in response!');
        throw Exception('فشل تسجيل الدخول');
      }

      // 3. Fetch user profile from admin_users table
      print('📋 Fetching user profile from admin_users table...');
      print('   Looking for user_id: ${response.user!.id}');
      final adminUser = await _getUserProfile(response.user!.id);

      print('');
      print('✅ User Profile Found:');
      print('   Name: ${adminUser.name}');
      print('   Email: ${adminUser.email}');
      print('   Role: ${adminUser.role}');
      print('   Active: ${adminUser.isActive}');
      print('');

      // 4. Check if user is active
      if (!adminUser.isActive) {
        print('❌ ERROR: User account is inactive!');
        await logout();
        throw Exception('هذا الحساب غير نشط. يرجى التواصل مع المسؤول');
      }

      // 5. Save session for "Remember Me"
      print('💾 Saving session...');
      await _saveSession(response.session!);

      print('');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('✅ LOGIN SUCCESSFUL!');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('');

      return adminUser;

    } on AuthException catch (e) {
      // ✅ FIXED: Removed stackTrace reference
      print('');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('❌ SUPABASE AUTH EXCEPTION');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📛 Message: "${e.message}"');
      print('🔢 Status Code: ${e.statusCode}');
      print('📍 Type: ${e.runtimeType}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('');

      throw _handleAuthException(e);

    } catch (e, stackTrace) {
      // ✅ Only general exceptions have stackTrace
      print('');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('❌ GENERAL EXCEPTION');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📛 Error: $e');
      print('🔍 Type: ${e.runtimeType}');
      print('📍 Stack Trace:');
      print(stackTrace.toString());
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('');

      throw Exception('خطأ في تسجيل الدخول: ${e.toString()}');
    }
  }
  /// Logout current user
  Future<void> logout() async {
    try {
      await _supabaseService.client.auth.signOut();
      await _clearSession();
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('فشل تسجيل الخروج: ${e.toString()}');
    }
  }

  /// Get currently authenticated user
  /// Returns null if no user is logged in
  Future<AdminUser?> getCurrentUser() async {
    try {
      final currentUser = _supabaseService.currentUser;

      if (currentUser == null) {
        // Try to restore session
        final restored = await _restoreSession();
        if (!restored) return null;

        // Get user after session restore
        final restoredUser = _supabaseService.currentUser;
        if (restoredUser == null) return null;

        return await _getUserProfile(restoredUser.id);
      }

      return await _getUserProfile(currentUser.id);
    } catch (e) {
      // If there's an error fetching profile, return null
      return null;
    }
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _supabaseService.isAuthenticated;
  }

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges {
    return _supabaseService.authStateChanges;
  }

  // ============================================
  // PASSWORD MANAGEMENT
  // ============================================

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseService.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'yourapp://reset-password', // Update with your deep link
      );
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('فشل إرسال رابط إعادة تعيين كلمة المرور: ${e.toString()}');
    }
  }

  /// Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabaseService.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('فشل تحديث كلمة المرور: ${e.toString()}');
    }
  }

  // ============================================
  // USER PROFILE MANAGEMENT
  // ============================================

  /// Get user profile from database
// lib/data/repositories/auth_repository.dart

  Future<AdminUser> _getUserProfile(String userId) async {
    try {
      print('📋 Fetching profile for user_id: $userId');

      final response = await _supabaseService.client
          .from('admin_users')
          .select()
          .eq('id', userId)
          .single();

      print('✅ Profile data received:');
      print('   Raw JSON: $response');

      final adminUser = AdminUser.fromJson(response);

      print('✅ Parsed AdminUser:');
      print('   ID: ${adminUser.id}');
      print('   Name: ${adminUser.name}');
      print('   Email: ${adminUser.email}');
      print('   Role: ${adminUser.role}');

      return adminUser;

    } catch (e, stackTrace) {
      print('');
      print('❌ Failed to fetch user profile!');
      print('   User ID searched: $userId');
      print('   Error: $e');
      print('   Error Type: ${e.runtimeType}');
      print('   Stack Trace:');
      print(stackTrace.toString());
      print('');

      throw Exception('فشل جلب بيانات المستخدم: ${e.toString()}');
    }
  }
  /// Update user profile
  Future<AdminUser> updateProfile({
    required String userId,
    String? name,
    String? department,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (name != null) updates['name'] = name;
      if (department != null) updates['department'] = department;

      if (updates.isEmpty) {
        return await _getUserProfile(userId);
      }

      final response = await _supabaseService.client
          .from('admin_users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return AdminUser.fromJson(response);
    } catch (e) {
      throw Exception('فشل تحديث الملف الشخصي: ${e.toString()}');
    }
  }

  // ============================================
  // SESSION MANAGEMENT (Remember Me)
  // ============================================

  /// Save session for "Remember Me" functionality
  Future<void> _saveSession(Session session) async {
    try {
      await StorageService.instance.setString(
        'access_token',
        session.accessToken,
      );
      await StorageService.instance.setString(
        'refresh_token',
        session.refreshToken ?? '',
      );
      await StorageService.instance.setBool('remember_me', true);
    } catch (e) {
      // Don't throw error, just log
      print('Failed to save session: $e');
    }
  }

  /// Restore session from storage
  Future<bool> _restoreSession() async {
    try {
      final rememberMe = StorageService.instance.getBool('remember_me');
      if (!rememberMe) return false;

      final accessToken = StorageService.instance.getString('access_token');
      final refreshToken = StorageService.instance.getString('refresh_token');

      if (accessToken == null || refreshToken == null) return false;

      // Set session in Supabase
      await _supabaseService.client.auth.setSession(refreshToken);

      return true;
    } catch (e) {
      print('Failed to restore session: $e');
      return false;
    }
  }

  /// Clear saved session
  Future<void> _clearSession() async {
    try {
      await StorageService.instance.remove('access_token');
      await StorageService.instance.remove('refresh_token');
      await StorageService.instance.remove('remember_me');
    } catch (e) {
      print('Failed to clear session: $e');
    }
  }

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Handle Supabase AuthException and return user-friendly message
// lib/data/repositories/auth_repository.dart

  Exception _handleAuthException(AuthException e) {
    // Log the raw error for debugging
    print('🔍 Analyzing Supabase error...');
    print('   Original message: "${e.message}"');

    // Normalize the message for comparison (lowercase, trimmed)
    final message = e.message.toLowerCase().trim();
    print('   Normalized: "$message"');

    // Check for various forms of "invalid credentials"
    if (message.contains('invalid') ||
        message.contains('incorrect') ||
        message.contains('wrong')) {
      if (message.contains('credential') ||
          message.contains('password') ||
          message.contains('email') ||
          message.contains('login')) {
        print('   ✓ Detected: Invalid credentials error');
        return Exception('البريد الإلكتروني أو كلمة المرور غير صحيحة');
      }
    }

    // Check for email confirmation
    if (message.contains('email') &&
        (message.contains('confirm') || message.contains('verif'))) {
      print('   ✓ Detected: Email not confirmed');
      return Exception('يرجى تأكيد البريد الإلكتروني أولاً');
    }

    // Check for already registered
    if (message.contains('already') && message.contains('register')) {
      print('   ✓ Detected: User already registered');
      return Exception('هذا البريد الإلكتروني مسجل مسبقاً');
    }

    // Check for user not found
    if (message.contains('user') &&
        (message.contains('not found') || message.contains('does not exist'))) {
      print('   ✓ Detected: User not found');
      return Exception('المستخدم غير موجود');
    }

    // Check for network errors
    if (message.contains('network') ||
        message.contains('connection') ||
        message.contains('timeout')) {
      print('   ✓ Detected: Network error');
      return Exception('خطأ في الاتصال بالخادم. يرجى التحقق من الإنترنت');
    }

    // If no match, return the original error with context
    print('   ✗ No pattern match - returning original error');
    return Exception('خطأ في المصادقة: ${e.message}');
  }}