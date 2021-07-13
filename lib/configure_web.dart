import 'package:flutter_web_plugins/flutter_web_plugins.dart';
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
  setUrlStrategy(PathUrlStrategy());
}
