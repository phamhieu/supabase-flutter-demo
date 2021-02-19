import 'package:supabase/supabase.dart';

const String SPLASH_SCREEN = 'SPLASH_SCREEN';
const String SIGNIN_SCREEN = 'SIGNIN_SCREEN';
const String SIGNUP_SCREEN = 'SIGNUP_SCREEN';
const String PASSWORDRECOVER_SCREEN = 'PASSWORDRECOVER_SCREEN';

const PERSIST_SESSION_KEY = 'PERSIST_SESSION_KEY';

const SUPABASE_URL = '';
const SUPABASE_ANNON_KEY = '';
final supabaseClient = SupabaseClient(SUPABASE_URL, SUPABASE_ANNON_KEY);
