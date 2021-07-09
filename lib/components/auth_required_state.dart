import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRequiredState<T extends StatefulWidget>
    extends SupabaseAuthRequiredState<T> {
  @override
  void onUnauthenticated() {
    print('***** onUnauthenticated');
    Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
  }
}
