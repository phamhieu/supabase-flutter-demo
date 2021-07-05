import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';
import 'package:url_launcher/url_launcher.dart';

const SUPABSE_PERSIST_SESSION_KEY = 'SUPABSE_PERSIST_SESSION_KEY';

class Supabase {
  SupabaseClient _client = SupabaseClient('', '');
  GotrueSubscription? _initialClientSubscription;
  bool _initialUriIsHandled = false;

  Supabase(String supabaseUrl, String supabaseAnonKey) {
    _client = SupabaseClient(supabaseUrl, supabaseAnonKey);
    _initialClientSubscription =
        _client.auth.onAuthStateChange(_onAuthStateChange);
  }

  void dispose() {
    if (_initialClientSubscription != null) {
      _initialClientSubscription!.data!.unsubscribe();
    }
  }

  SupabaseClient get client {
    print('***** get Supabase client');
    return _client;
  }

  void initialClient(String supabaseUrl, String supabaseAnonKey) async {
    print('***** initialClient initialClient initialClient');

    if (_initialClientSubscription != null) {
      _initialClientSubscription!.data!.unsubscribe();
    }

    _client = SupabaseClient(supabaseUrl, supabaseAnonKey);
    _initialClientSubscription =
        _client.auth.onAuthStateChange(_onAuthStateChange);
  }

  void _onAuthStateChange(AuthChangeEvent event, Session? session) {
    print('**** onAuthStateChange: $event');
    if (event == AuthChangeEvent.signedIn && session != null) {
      print(session.persistSessionString);
      _persistSession(session.persistSessionString);
    } else if (event == AuthChangeEvent.signedOut) {
      _removePersistSession();
    }
  }

  void _persistSession(String persistSessionString) async {
    print('***** persistSession persistSession persistSession');
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SUPABSE_PERSIST_SESSION_KEY, persistSessionString);
  }

  void _removePersistSession() async {
    print('***** _removePersistSession _removePersistSession');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(SUPABSE_PERSIST_SESSION_KEY);
  }

  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  bool shouldHandleInitialUri() {
    if (_initialUriIsHandled)
      return false;
    else {
      _initialUriIsHandled = true;
      return true;
    }
  }
}

extension GoTrueClientSignInProvider on GoTrueClient {
  Future<bool> signInWithProvider(Provider? provider,
      {AuthOptions? options}) async {
    final res = await signIn(
      provider: provider,
      options: options,
    );
    return await launch(res.url!);
  }
}
