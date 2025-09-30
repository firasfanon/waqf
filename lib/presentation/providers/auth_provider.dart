import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user.dart';
import '../../data/services/supabase_service.dart';
import '../../data/repositories/user_repository.dart';

// Supabase service provider
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService.instance;
});

// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final supabaseService = ref.read(supabaseServiceProvider);
  return UserRepository(supabaseService);
});

// Auth state provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
      (ref) => AuthStateNotifier(
    ref.read(supabaseServiceProvider),
    ref.read(userRepositoryProvider),
  ),
);

// Auth state
class AuthState {
  final User? user;
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
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth state notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  final SupabaseService _supabaseService;
  final UserRepository _userRepository;

  AuthStateNotifier(this._supabaseService, this._userRepository)
      : super(const AuthState()) {
    _checkAuthState();
  }

  // Check initial auth state
  Future<void> _checkAuthState() async {
    state = state.copyWith(isLoading: true);

    try {
      if (_supabaseService.isAuthenticated) {
        final user = await _userRepository.getCurrentUser();
        state = state.copyWith(
          user: user,
          isAuthenticated: user != null,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // Sign in
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _supabaseService.signIn(
        email: email,
        password: password,
      );

      final user = await _userRepository.getCurrentUser();

      if (user != null) {
        await _userRepository.updateLastLogin(user.id);

        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          error: 'فشل في تحميل بيانات المستخدم',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'فشل تسجيل الدخول: ${e.toString()}',
        isLoading: false,
      );
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);

    try {
      await _supabaseService.signOut();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _supabaseService.resetPassword(email);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }

  // Check permission
  bool hasPermission(SystemModule module, String permission) {
    if (state.user == null) return false;
    return state.user!.permissions.hasPermission(module, permission);
  }

  // Check if user can access governorate
  bool canAccessGovernorate(String governorate) {
    if (state.user == null) return false;
    return state.user!.permissions.canAccessGovernorate(governorate);
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).user;
});

// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});