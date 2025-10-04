import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service class for managing Supabase operations
/// Follows Singleton pattern - one instance for the entire app
class SupabaseService {
  // Private constructor prevents external instantiation
  SupabaseService._();

  // Singleton instance - created once and reused
  static final SupabaseService _instance = SupabaseService._();

  // Factory constructor - returns the same instance every time
  factory SupabaseService() => _instance;

  /// Access the Supabase client
  /// No need to store it - we get it from the global Supabase instance
  SupabaseClient get client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      throw Exception(
          'Supabase not initialized. Make sure Supabase.initialize() '
              'is called in main() before using SupabaseService.'
      );
    }
  }

  /// Check if Supabase is properly initialized
  bool get isInitialized {
    try {
      Supabase.instance.client;
      return true;
    } catch (e) {
      return false;
    }
  }

  // ============ Authentication Methods ============

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await client.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  User? get currentUser => client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  // ============ Storage Methods ============

  Future<String> uploadFile({
    required String bucket,
    required String path,
    required List<int> bytes,
  }) async {
    try {
      final Uint8List uint8bytes = Uint8List.fromList(bytes);
      await client.storage.from(bucket).uploadBinary(path, uint8bytes);
      return client.storage.from(bucket).getPublicUrl(path);
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  // ============ Realtime Methods ============

  RealtimeChannel subscribe(
      String table,
      void Function(PostgresChangePayload payload) callback,
      ) {
    return client
        .channel('public:$table')
        .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: table,
      callback: callback,
    )
        .subscribe();
  }

  // ============ Database Query Methods ============

  Future<List<Map<String, dynamic>>> select({
    required String table,
    String columns = '*',
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    try {
      PostgrestFilterBuilder query = client.from(table).select(columns);

      if (filters != null) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      PostgrestTransformBuilder transformBuilder = query;

      if (orderBy != null) {
        transformBuilder = transformBuilder.order(orderBy, ascending: ascending);
      }

      if (limit != null) {
        transformBuilder = transformBuilder.limit(limit);
      }

      final response = await transformBuilder;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Select query failed: $e');
    }
  }

  // ============ RPC Methods ============

  Future<dynamic> rpc(String functionName, {Map<String, dynamic>? params}) async {
    try {
      return await client.rpc(functionName, params: params);
    } catch (e) {
      throw Exception('RPC call failed: $e');
    }
  }
}