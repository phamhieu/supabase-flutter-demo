import 'dart:async';

import 'package:demoapp/utils/supabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/screens/profile_screen.dart';
import 'package:demoapp/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  void showSignIn() {
    var _duration = new Duration(seconds: 1);
    new Timer(_duration, () {
      Navigator.of(context).pushReplacementNamed(SIGNIN_SCREEN);
    });
  }

  void showWelcome(String title) {
    var _duration = new Duration(seconds: 1);
    new Timer(_duration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ProfileScreen(title);
          },
        ),
      );
    });
  }

  void _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    bool exist = prefs.containsKey(PERSIST_SESSION_KEY);
    if (!exist) {
      return showSignIn();
    }

    String? jsonStr = prefs.getString(PERSIST_SESSION_KEY);
    if (jsonStr == null) {
      return showSignIn();
    }

    final response = await Supabase.client.auth.recoverSession(jsonStr);
    if (response.error != null) {
      prefs.remove(PERSIST_SESSION_KEY);
      return showSignIn();
    } else {
      final title = 'Welcome ${response.data!.user!.email}';
      showWelcome(title);
    }
  }

  @override
  void initState() {
    super.initState();

    _restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: SizedBox(
            height: 50.0,
            child: Image.asset(
              "assets/images/logo-light.png",
            ),
          ),
        ),
      ),
    );
  }
}
