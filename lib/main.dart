import 'package:demoapp/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/screens/forgot_password.dart';
import 'package:demoapp/screens/signin_screen.dart';
import 'package:demoapp/screens/signup_screen.dart';
import 'package:demoapp/screens/splash_screen.dart';
import 'package:demoapp/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // init Supabase singleton
  print('***** main init Supabase');
  Supabase(
    url: supabaseUrl,
    anonKey: supabaseAnnonKey,
    authCallbackUrlHostname: 'login-callback',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Demo',
      home: SplashScreen(),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: <String, WidgetBuilder>{
        '/signIn': (context) => SignInScreen(),
        '/signUp': (context) => SignUpScreen(),
        '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
