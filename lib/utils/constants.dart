import 'package:demoapp/components/supabase.dart';

const String SPLASH_SCREEN = 'SPLASH_SCREEN';
const String SIGNIN_SCREEN = 'SIGNIN_SCREEN';
const String SIGNUP_SCREEN = 'SIGNUP_SCREEN';
const String PASSWORDRECOVER_SCREEN = 'PASSWORDRECOVER_SCREEN';

const AUTH_REDIRECT_URI = 'io.supabase.flutterdemo://login-callback';

/// TODO: Add your SUPABASE_URL / SUPABASE_KEY here
const SUPABASE_URL = 'SUPABASE_URL';
const SUPABASE_ANNON_KEY = 'SUPABASE_KEY';
final mySupabase = Supabase(SUPABASE_URL, SUPABASE_ANNON_KEY);
