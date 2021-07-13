import 'package:supabase_demo/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void configureApp() {
  // init Supabase singleton
  Supabase(
    url: supabaseUrl,
    anonKey: supabaseAnnonKey,
    authCallbackUrlHostname: 'login-callback',
    debug: true,
  );
}
