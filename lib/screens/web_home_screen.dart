import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/components/auth_state.dart';

class WebHomeScreen extends StatefulWidget {
  @override
  _WebHomeScreenState createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends AuthState<WebHomeScreen>
    with SingleTickerProviderStateMixin {
  Timer? recoverSessionTimer;

  @override
  void initState() {
    super.initState();

    final uriParameters = Supabase().parseUriParameters(Uri.base);
    if (uriParameters.containsKey('access_token') &&
        uriParameters.containsKey('refresh_token') &&
        uriParameters.containsKey('expires_in')) {
      /// Uri.base is a auth redirect link
      /// Call recoverSessionFromUrl to continue
      recoverSessionFromUrl(Uri.base);
    }
  }

  Future<bool> onSignIn() async {
    final hasAccessToken = await Supabase().hasAccessToken;
    String route = '';
    if (hasAccessToken) {
      route = '/profile';
    } else {
      route = '/signIn';
    }
    stopAuthObserver();
    Navigator.pushNamed(context, route).then((_) => startAuthObserver());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter user management'),
      ),
      body: Center(
        child: SizedBox(
          height: 50.0,
          child: ElevatedButton(
            onPressed: onSignIn,
            child: const Text('Sign in'),
          ),
        ),
      ),
    );
  }
}
