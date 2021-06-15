import 'package:flutter/material.dart';
import 'package:demoapp/Screens/password_recover.dart';
import 'package:demoapp/Screens/signin_screen.dart';
import 'package:demoapp/Screens/signup_screen.dart';
import 'package:demoapp/Screens/splash_screen.dart';
import 'package:demoapp/constants.dart';

void main() {
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
        SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
        SIGNIN_SCREEN: (BuildContext context) => SignInScreen(),
        SIGNUP_SCREEN: (BuildContext context) => SignUpScreen(),
        PASSWORDRECOVER_SCREEN: (BuildContext context) =>
            PasswordRecoverScreen(),
      },
    );
  }
}
