import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';
import 'screens/change_password.dart';
import 'screens/forgot_password.dart';
import 'screens/profile_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/web_home_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureApp();
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
        '/signIn': (_) => SignInScreen(),
        '/signUp': (_) => SignUpScreen(),
        '/forgotPassword': (_) => ForgotPasswordScreen(),
        '/profile': (_) => ProfileScreen(),
        '/profile/changePassword': (_) => ChangePasswordScreen(),
      },
      onGenerateRoute: generateRoute,
    );
  }
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    default:
      return MaterialPageRoute(
          builder: (_) => kIsWeb ? WebHomeScreen() : SplashScreen());
  }
}
