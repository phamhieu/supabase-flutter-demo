import 'package:flutter/foundation.dart';
import 'package:supabase_demo/screens/change_password.dart';
import 'package:supabase_demo/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_demo/screens/forgot_password.dart';
import 'package:supabase_demo/screens/signin_screen.dart';
import 'package:supabase_demo/screens/signup_screen.dart';
import 'package:supabase_demo/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/web_home_screen.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // init Supabase singleton
  Supabase(
    url: supabaseUrl,
    anonKey: supabaseAnnonKey,
    authCallbackUrlHostname: 'login-callback',
    debug: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Demo',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/signIn': (_) => SignInScreen(),
        '/signUp': (_) => SignUpScreen(),
        '/forgotPassword': (_) => const ForgotPasswordScreen(),
        '/profile': (_) => ProfileScreen(),
        '/profile/changePassword': (_) => const ChangePasswordScreen(),
      },
      onGenerateRoute: generateRoute,
    );
  }
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    default:
      return MaterialPageRoute(
          builder: (_) => kIsWeb ? WebHomeScreen() : SplashScreen());
  }
}
