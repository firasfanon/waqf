import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock classes for Supabase
class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class MockSession extends Mock implements Session {}

class MockAuthResponse extends Mock implements AuthResponse {}

class MockPostgrestResponse extends Mock {}

// Helper to create mock Supabase client with common setup
MockSupabaseClient createMockSupabaseClient({
  MockUser? user,
  MockSession? session,
}) {
  final mockClient = MockSupabaseClient();
  final mockAuth = MockGoTrueClient();

  // Setup auth mock
  when(mockClient.auth).thenReturn(mockAuth);

  if (user != null) {
    when(mockAuth.currentUser).thenReturn(user);
  }

  if (session != null) {
    when(mockAuth.currentSession).thenReturn(session);
  }

  return mockClient;
}

// Helper to create mock authenticated user
MockUser createMockUser({
  String id = 'test-user-id',
  String email = 'test@example.com',
  Map<String, dynamic>? userMetadata,
}) {
  final mockUser = MockUser();

  when(mockUser.id).thenReturn(id);
  when(mockUser.email).thenReturn(email);
  when(mockUser.userMetadata).thenReturn(userMetadata ?? {});

  return mockUser;
}

// Helper to create mock session
MockSession createMockSession({
  String? accessToken,
  String? refreshToken,
  MockUser? user,
}) {
  final mockSession = MockSession();

  when(mockSession.accessToken).thenReturn(accessToken ?? 'mock-access-token');
  when(mockSession.refreshToken)
      .thenReturn(refreshToken ?? 'mock-refresh-token');

  if (user != null) {
    when(mockSession.user).thenReturn(user);
  }

  return mockSession;
}
