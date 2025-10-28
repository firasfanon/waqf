// lib/data/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() => _instance;

  SupabaseService._internal();

  // Get the Supabase client with safety check
  SupabaseClient get client {
    try {
      if (Supabase.instance.isInitialized) {
        return Supabase.instance.client;
      } else {
        throw Exception(
          'Supabase is not initialized. Please check your .env configuration.',
        );
      }
    } catch (e) {
      debugPrint('❌ Error accessing Supabase client: $e');
      rethrow;
    }
  }

  // Check if Supabase is properly initialized
  bool get isInitialized {
    try {
      return Supabase.instance.isInitialized;
    } catch (e) {
      return false;
    }
  }

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