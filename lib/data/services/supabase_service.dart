// lib/data/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() => _instance;

  SupabaseService._internal();

  // Get the Supabase client
  SupabaseClient get client => Supabase.instance.client;

  // ============ AUTH HELPERS ============

  /// Check if user is currently authenticated
  bool get isAuthenticated => client.auth.currentSession != null;

  /// Get current user
  User? get currentUser => client.auth.currentUser;

  /// Get current session
  Session? get currentSession => client.auth.currentSession;

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // ============ DATABASE HELPERS ============

  /// Query a table
  SupabaseQueryBuilder from(String table) {
    return client.from(table);
  }

  /// Execute RPC (Remote Procedure Call)
  Future<dynamic> rpc(String functionName, {Map<String, dynamic>? params}) {
    return client.rpc(functionName, params: params);
  }

  /// Upload file to storage
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required dynamic file,
  }) async {
    await client.storage.from(bucket).upload(path, file);
    return client.storage.from(bucket).getPublicUrl(path);
  }

  /// Delete file from storage
  Future<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    await client.storage.from(bucket).remove([path]);
  }
}