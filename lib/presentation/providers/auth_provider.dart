// lib/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../data/repositories/auth_repository.dart';
import '../../data/models/admin_user.dart';
import 'supabase_providers.dart';

// ============================================
// REPOSITORY PROVIDER
// ============================================

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return AuthRepository(supabaseService);
});

// ============================================
// AUTH STATE PROVIDER
// ============================================

/// Authentication state
class AuthState {
  final AdminUser? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    AdminUser? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Auth state notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthStateNotifier(this._authRepository) : super(const AuthState()) {
    _init();
  }

  /// Initialize - check if user is already logged in
  Future<void> _init() async {
    state = state.copyWith(isLoading: true);

    try {
      final user = await _authRepository.getCurrentUser();

      if (user != null) {
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
          clearError: true,
        );
      } else {
        state = const AuthState();
      }
    } catch (e) {
      state = const AuthState();
    }

    // Listen to auth state changes
    _authRepository.authStateChanges.listen((authState) {
      if (authState.event == supabase.AuthChangeEvent.signedOut) {
        state = const AuthState();
      }
    });
  }

  /// Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await _authRepository.login(email, password);

      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      state = const AuthState();
    } catch (e) {
      // Even if logout fails, clear local state
      state = const AuthState();
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _authRepository.resetPassword(email);
      state = state.copyWith(isLoading: false, clearError: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      rethrow;
    }
  }

  // Add to lib/presentation/providers/auth_provider.dart

  /// Update password
  Future<void> updatePassword(String newPassword) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _authRepository.updatePassword(newPassword);

      state = state.copyWith(isLoading: false, clearError: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      rethrow;
    }
  }

  /// Update profile
  Future<void> updateProfile({
    String? name,
    String? department,
  }) async {
    if (state.user == null) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final updatedUser = await _authRepository.updateProfile(
        userId: state.user!.id,
        name: name,
        department: department,
      );

      state = state.copyWith(
        user: updatedUser,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      rethrow;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Auth state provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
      (ref) => AuthStateNotifier(ref.watch(authRepositoryProvider)),
);

// ============================================
// CONVENIENCE PROVIDERS
// ============================================

/// Current user provider
final currentUserProvider = Provider<AdminUser?>((ref) {
  return ref.watch(authStateProvider).user;
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

/// Is admin provider
final isAdminProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isAdmin ?? false;
});