import 'dart:async';

import 'package:demoapp/components/auth_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends AuthState<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    /// a timer to slow down session restore
    /// If not user can't really see the splash screen
    var _duration = new Duration(seconds: 1);
    new Timer(_duration, () {
      this.recoverSupabaseSession();
    });
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
