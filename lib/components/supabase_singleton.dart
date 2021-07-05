import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';
import 'package:url_launcher/url_launcher.dart';

const SUPABSE_PERSIST_SESSION_KEY = 'SUPABSE_PERSIST_SESSION_KEY';

class Supabase {
  /// TODO: Add your SUPABASE_URL / SUPABASE_KEY here
  static const SUPABASE_URL = 'SUPABASE_URL';
  static const SUPABASE_ANNON_KEY = 'SUPABASE_KEY';
  static final _client = SupabaseClient(SUPABASE_URL, SUPABASE_ANNON_KEY);
  static SupabaseClient get client => _client;

  bool _initialUriIsHandled = false;

  Supabase._privateConstructor() {
    _client.auth.onAuthStateChange(_onAuthStateChange);
  }

  static final Supabase _instance = Supabase._privateConstructor();

  factory Supabase() {
    return _instance;
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
