import 'package:demoapp/components/supabase_deep_linking_mixin.dart';
import 'package:demoapp/components/supabase_lifecycle_state.dart';
import 'package:demoapp/utils/supabase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';

abstract class SupabaseAuthState<T extends StatefulWidget>
    extends SupabaseLifecycleState<T> with SupabaseDeepLinkingMixin {
  @override
  void initState() {
    super.initState();
    Supabase.client.auth.onAuthStateChange(_onAuthStateChange);
  }

  @override
  void onHandledDeepLink() {}

  void _onAuthStateChange(AuthChangeEvent event, Session? session) {
    if (event == AuthChangeEvent.passwordRecovery && session != null) {
      onPasswordRecovery(session);
    }
  }

  /// This method helps recover/refresh session if it's available
  /// Should be called on a Splash screen when app starts.
  void recoverSupabaseSession() async {
    final prefs = await SharedPreferences.getInstance();
    bool exist = prefs.containsKey(SUPABSE_PERSIST_SESSION_KEY);
    if (!exist) {
      return onUnauthenticated();
    }

    String? jsonStr = prefs.getString(SUPABSE_PERSIST_SESSION_KEY);
    if (jsonStr == null) {
      return onUnauthenticated();
    }

    final response = await Supabase.client.auth.recoverSession(jsonStr);
    if (response.error != null) {
      prefs.remove(SUPABSE_PERSIST_SESSION_KEY);
      return onUnauthenticated();
    } else {
      onAuthenticated(response.data!);
    }
  }

  void onResumed() async {
    print('***** onResumed onResumed onResumed');
    final prefs = await SharedPreferences.getInstance();
    String? persistSessionString = prefs.getString(SUPABSE_PERSIST_SESSION_KEY);
    if (persistSessionString != null) {
      await Supabase.client.auth.recoverSession(persistSessionString);
    }
  }

  void onUnauthenticated();
  void onAuthenticated(Session session);
  void onPasswordRecovery(Session session);
}
