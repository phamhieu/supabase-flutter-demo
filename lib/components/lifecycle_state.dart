import 'package:demoapp/utils/constants.dart';
import 'package:demoapp/utils/supabase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LifecycleState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void onResumed() async {
    print('***** onResumed onResumed onResumed');
    final prefs = await SharedPreferences.getInstance();
    String? persistSessionString = prefs.getString(PERSIST_SESSION_KEY);
    if (persistSessionString != null) {
      await Supabase.client.auth.recoverSession(persistSessionString);
    }
  }
}
