import 'package:demoapp/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';

class Supabase {
  /// TODO: Add your Supabase URL / ANNON KEY here
  static const SUPABASE_URL = 'https://pgshhamktpsgnptsadwz.supabase.co';
  static const SUPABASE_ANNON_KEY =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyMTg5OTA4MSwiZXhwIjoxOTM3NDc1MDgxfQ.qSW9CJnkqgrE2eh9yIU0coDEADNQDGamlNaPh-JxQTw';
  static final _client = SupabaseClient(SUPABASE_URL, SUPABASE_ANNON_KEY);
  static SupabaseClient get client => _client;

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
    prefs.setString(PERSIST_SESSION_KEY, persistSessionString);
  }

  void _removePersistSession() async {
    print('***** _removePersistSession _removePersistSession');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(PERSIST_SESSION_KEY);
  }
}
