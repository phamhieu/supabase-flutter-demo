import 'dart:async';

import 'package:demoapp/utils/supabase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

mixin SupabaseDeepLinkingMixin<T extends StatefulWidget> on State<T> {
  late StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      print('_handleIncomingLinks called');
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (mounted && uri != null) {
          print('got uri: $uri');
          onHandleDeepLink(uri);
          _handleDeepLink(uri);
        }
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
      });
    }
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialUri() async {
    if (!Supabase().shouldHandleInitialUri()) return;

    print('_handleInitialUri called');
    try {
      final uri = await getInitialUri();
      if (uri != null) {
        print('got initial uri: $uri');
        if (mounted) {
          onHandleDeepLink(uri);
          _handleDeepLink(uri);
        }
      }
    } on PlatformException {
      // Platform messages may fail but we ignore the exception
      print('falied to get initial uri');
    } on FormatException catch (err) {
      if (!mounted) return;
      print('malformed initial uri: $err');
    }
  }

  void _handleDeepLink(Uri uri) async {
    print('uri.scheme: ${uri.scheme}');
    print('uri.host: ${uri.host}');

    await Supabase.client.auth.getSessionFromUrl(uri);
    onHandledDeepLink();
  }

  // As a notify that deep link received and is processing
  void onHandleDeepLink(Uri uri) {}

  // As a callback after deep link handled
  void onHandledDeepLink() {}
}
