import 'package:supabase/supabase.dart';

const String SPLASH_SCREEN = 'SPLASH_SCREEN';
const String SIGNIN_SCREEN = 'SIGNIN_SCREEN';
const String SIGNUP_SCREEN = 'SIGNUP_SCREEN';
const String PASSWORDRECOVER_SCREEN = 'PASSWORDRECOVER_SCREEN';

const PERSIST_SESSION_KEY = 'PERSIST_SESSION_KEY';

const OAUTH_REDIRECT_URI = 'io.supabase.demoapp://login-callback';

/// TODO: Add your Supabase URL / ANNON KEY here
const SUPABASE_URL = 'https://pgshhamktpsgnptsadwz.supabase.co';
const SUPABASE_ANNON_KEY =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyMTg5OTA4MSwiZXhwIjoxOTM3NDc1MDgxfQ.qSW9CJnkqgrE2eh9yIU0coDEADNQDGamlNaPh-JxQTw';
final supabaseClient = SupabaseClient(SUPABASE_URL, SUPABASE_ANNON_KEY);
