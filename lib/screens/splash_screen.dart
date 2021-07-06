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
  Timer? recoverSessionTimer;

  @override
  void initState() {
    super.initState();

    /// a timer to slow down session restore
    /// If not user can't really see the splash screen
    var _duration = new Duration(seconds: 1);
    recoverSessionTimer = new Timer(_duration, () {
      print('***** splash screen trigger recoverSupabaseSession');
      this.recoverSupabaseSession();
    });
  }

  /// on received auth deeplink, we should cancel recoverSessionTimer
  /// and wait for auth deep link handling result
  @override
  void onReceivedAuthDeeplink(Uri uri) {
    print('***** splash screen onReceivedAuthDeeplink ${uri.toString()}');
    if (recoverSessionTimer != null) {
      recoverSessionTimer!.cancel();
    }
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
