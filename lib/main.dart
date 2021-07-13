import 'package:supabase_demo/screens/change_password.dart';
import 'package:supabase_demo/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_demo/screens/forgot_password.dart';
import 'package:supabase_demo/screens/signin_screen.dart';
import 'package:supabase_demo/screens/signup_screen.dart';
import 'package:supabase_demo/screens/splash_screen.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Demo',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => SplashScreen(),
        '/signIn': (_) => SignInScreen(),
        '/signUp': (_) => SignUpScreen(),
        '/forgotPassword': (_) => const ForgotPasswordScreen(),
        '/profile': (_) => ProfileScreen(),
        '/profile/changePassword': (_) => const ChangePasswordScreen(),
      },
    );
  }
}
