import 'package:supabase/supabase.dart';

/// TODO: Add your Supabase URL / ANNON KEY here
const SUPABASE_URL = 'https://pgshhamktpsgnptsadwz.supabase.co';
const SUPABASE_ANNON_KEY =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyMTg5OTA4MSwiZXhwIjoxOTM3NDc1MDgxfQ.qSW9CJnkqgrE2eh9yIU0coDEADNQDGamlNaPh-JxQTw';
final supabaseClient = SupabaseClient(SUPABASE_URL, SUPABASE_ANNON_KEY);
