import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_constants.dart';

class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient _client;

  SupabaseService._();

  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: AppConstants.baseUrl,
        anonKey: AppConstants.apiKey,
      );

      instance._client = Supabase.instance.client;
    } catch (e) {
      throw Exception('Failed to initialize Supabase: $e');
    }
  }

  SupabaseClient get client => _client;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
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
      return await _client.auth.signUp(
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
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Future<String> uploadFile({
    required String bucket,
    required String path,
    required List<int> bytes,
  }) async {
    try {
      final Uint8List uint8bytes = Uint8List.fromList(bytes);
      await _client.storage.from(bucket).uploadBinary(path, uint8bytes);
      return _client.storage.from(bucket).getPublicUrl(path);
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  RealtimeChannel subscribe(
      String table,
      void Function(PostgresChangePayload payload) callback,
      ) {
    return _client
        .channel('public:$table')
        .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: table,
      callback: callback,
    )
        .subscribe();
  }

  Future<List<Map<String, dynamic>>> select({
    required String table,
    String columns = '*',
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    try {
      PostgrestFilterBuilder query = _client.from(table).select(columns);

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

  Future<dynamic> rpc(String functionName, {Map<String, dynamic>? params}) async {
    try {
      return await _client.rpc(functionName, params: params);
    } catch (e) {
      throw Exception('RPC call failed: $e');
    }
  }
}