import 'package:flutter/material.dart';
import 'package:demoapp/screens/password_recover.dart';
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
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANNON_KEY,
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
        SIGNIN_SCREEN: (BuildContext context) => SignInScreen(),
        SIGNUP_SCREEN: (BuildContext context) => SignUpScreen(),
        PASSWORDRECOVER_SCREEN: (BuildContext context) =>
            PasswordRecoverScreen(),
      },
    );
  }
}
