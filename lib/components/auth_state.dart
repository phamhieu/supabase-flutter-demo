import 'package:demoapp/screens/profile_screen.dart';
import 'package:demoapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onUnauthenticated() {
    print('***** onUnauthenticated');
    Navigator.of(context).pushReplacementNamed(SIGNIN_SCREEN);
  }

  @override
  void onAuthenticated(supabase.Session session) {
    print('***** onAuthenticated: $session');
    final title = 'Welcome ${Supabase().client.auth.currentUser!.email}';
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ProfileScreen(title);
        },
      ),
    );
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
