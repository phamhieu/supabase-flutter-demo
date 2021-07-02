import 'package:demoapp/components/auth_state.dart';
import 'package:demoapp/utils/supabase.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/screens/profile_screen.dart';
import 'package:demoapp/components/alert_modal.dart';
import 'package:demoapp/utils/constants.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:supabase/supabase.dart' as supabase;

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends AuthState<SignUpScreen> {
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  var email = '';
  var password = '';

  void _onSignUpPress(BuildContext context) async {
    final response = await Supabase.client.auth.signUp(email, password,
        options: supabase.AuthOptions(redirectTo: AUTH_REDIRECT_URI));
    if (response.error != null) {
      alertModal.show(context,
          title: 'Sign up failed', message: response.error!.message);
      _btnController.reset();
    } else if (response.data == null && response.user == null) {
      alertModal.show(context,
          title: 'Email verification required',
          message:
              "Please check your email and follow the instructions to verify your email address.");
      _btnController.success();
    } else {
      final title = 'Welcome ${response.data!.user!.email}';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ProfileScreen(title);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15.0),
            TextField(
              onChanged: (value) => setState(() {
                email = value;
              }),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your email address',
              ),
            ),
            SizedBox(height: 15.0),
            TextField(
              onChanged: (value) => setState(() {
                password = value;
              }),
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 15.0),
            RoundedLoadingButton(
              color: Colors.green,
              child: const Text(
                'Sign up',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              controller: _btnController,
              onPressed: () {
                _onSignUpPress(context);
              },
            ),
            TextButton(
              child: const Text("Already have an Account ? Sign in"),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(SIGNIN_SCREEN);
              },
            ),
          ],
        ),
      ),
    );
  }
}
