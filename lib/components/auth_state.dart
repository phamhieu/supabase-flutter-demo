import 'package:demoapp/components/supabase_auth_state.dart';
import 'package:demoapp/screens/profile_screen.dart';
import 'package:demoapp/utils/constants.dart';
import 'package:demoapp/utils/supabase.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart' as supabase;

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onUnauthenticated() {
    Navigator.of(context).pushReplacementNamed(SIGNIN_SCREEN);
  }

  @override
  void onAuthenticated(supabase.Session session) {
    final title = 'Welcome ${Supabase.client.auth.currentUser!.email}';
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
    // TODO: show password change screen
    throw UnimplementedError();
  }

  @override
  void onErrorAuthenticating(String message) {
    // TODO: implement onErrorAuthenticating
  }
}
