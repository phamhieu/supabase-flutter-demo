import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onUnauthenticated() {
    print('***** onUnauthenticated');
    Navigator.pushReplacementNamed(context, '/signIn');
  }

  @override
  void onAuthenticated(supabase.Session session) {
    print('***** onAuthenticated: $session');
    Navigator.pushReplacementNamed(context, '/profile');
  }

  @override
  void onPasswordRecovery(supabase.Session session) {
    print('***** onPasswordRecovery: $session');
    // TODO: show password change screen
    // throw UnimplementedError();
  }

  @override
  void onErrorAuthenticating(String message) {
    print('***** onErrorAuthenticating: $message');
    // TODO: implement onErrorAuthenticating
  }
}
