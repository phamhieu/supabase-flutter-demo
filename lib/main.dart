import 'package:demoapp/Screens/Map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/Screens/PasswordRecover/password_recover.dart';
import 'package:demoapp/Screens/Signin/signin_screen.dart';
import 'package:demoapp/Screens/Signup/signup_screen.dart';
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
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
        SIGNIN_SCREEN: (BuildContext context) => SignInScreen(),
        SIGNUP_SCREEN: (BuildContext context) => SignUpScreen(),
        MAP_SCREEN: (BuildContext context) => MapScreen(),
        PASSWORDRECOVER_SCREEN: (BuildContext context) =>
            PasswordRecoverScreen(),
      },
    );
  }
}
