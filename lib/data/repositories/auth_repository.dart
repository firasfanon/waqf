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
  Future<AdminUser> login(String email, String password) async {
    try {
      // 1. Authenticate with Supabase Auth
      final response = await _supabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // 2. Check if login was successful
      if (response.user == null) {
        throw Exception('فشل تسجيل الدخول');
      }

      // 3. Fetch user profile from admin_users table
      final adminUser = await _getUserProfile(response.user!.id);

      // 4. Check if user is active
      if (!adminUser.isActive) {
        await logout(); // Sign them out
        throw Exception('هذا الحساب غير نشط. يرجى التواصل مع المسؤول');
      }

      // 5. Save session for "Remember Me"
      await _saveSession(response.session!);

      return adminUser;
    } on AuthException catch (e) {
      // Handle Supabase auth errors
      throw _handleAuthException(e);
    } catch (e) {
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
  Future<AdminUser> _getUserProfile(String userId) async {
    try {
      final response = await _supabaseService.client
          .from('admin_users')
          .select()
          .eq('id', userId)
          .single();

      return AdminUser.fromJson(response);
    } catch (e) {
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
  Exception _handleAuthException(AuthException e) {
    switch (e.message) {
      case 'Invalid login credentials':
        return Exception('البريد الإلكتروني أو كلمة المرور غير صحيحة');
      case 'Email not confirmed':
        return Exception('يرجى تأكيد البريد الإلكتروني أولاً');
      case 'User already registered':
        return Exception('هذا البريد الإلكتروني مسجل مسبقاً');
      case 'User not found':
        return Exception('المستخدم غير موجود');
      default:
        return Exception('خطأ في المصادقة: ${e.message}');
    }
  }
}