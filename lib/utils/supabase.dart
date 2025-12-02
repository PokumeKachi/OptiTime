import 'package:supabase_flutter/supabase_flutter.dart';

class Auth {
  static SupabaseClient get _client => Supabase.instance.client;

  static Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) {
    return _client.auth.signUp(email: email, password: password);
  }

  static Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  static Future<AuthResponse> signInOrSignUp(
    String email,
    String password,
  ) async {
    try {
      return await _client.auth.signInWithPassword(
          email: email, password: password);
    } catch (_) {
      await _client.auth.signUp(email: email, password: password);
      return await _client.auth.signInWithPassword(
          email: email, password: password);
    }
  }

  static Future<void> signOut() => _client.auth.signOut();
}
