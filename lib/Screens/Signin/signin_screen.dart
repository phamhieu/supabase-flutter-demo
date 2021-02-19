import 'package:flutter/material.dart';
import 'package:gotrue/gotrue.dart';
import 'package:demoapp/Screens/Welcome/welcome_screen.dart';
import 'package:demoapp/components/alert_modal.dart';
import 'package:demoapp/components/link_button.dart';
import 'package:demoapp/components/rounded_input_field.dart';
import 'package:demoapp/components/rounded_password_field.dart';
import 'package:demoapp/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignInScreen> {
  final RoundedLoadingButtonController _signInEmailController =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _signInGithubController =
      new RoundedLoadingButtonController();
  var email = '';
  var password = '';

  void _onSignInPress(BuildContext context) async {
    final response =
        await supabaseClient.auth.signIn(email: email, password: password);
    if (response.error != null) {
      alertModal.show(context,
          title: 'Sign in failed', message: response.error.message);
      _signInEmailController.reset();
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(PERSIST_SESSION_KEY, response.data.persistSessionString);

      final title = 'Welcome ${response.data.user.email}';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return WelcomeScreen(title);
          },
        ),
      );
    }
  }

  void _onSignInWithGithub(BuildContext context) async {
    final response = await supabaseClient.auth.signIn(provider: Provider.github);
    if (await canLaunch(response.url)) {
      print('response.url: ${response.url}');
      await launch(response.url);
    } else {
      throw 'Could not launch ${response.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 25.0),
            RoundedInputField(
              hintText: "Email address",
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            SizedBox(height: 15.0),
            RoundedPasswordField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            SizedBox(height: 15.0),
            RoundedLoadingButton(
              child: Text('Sign in',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              controller: _signInEmailController,
              onPressed: () {
                _onSignInPress(context);
              },
            ),
            // SizedBox(height: 25.0),
            // RoundedLoadingButton(
            //   color: Colors.black87,
            //   child: Text('Sign in with Github',
            //       style: TextStyle(fontSize: 20, color: Colors.white)),
            //   controller: _signInGithubController,
            //   onPressed: () {
            //     _onSignInWithGithub(context);
            //   },
            // ),
            SizedBox(height: 35.0),
            LinkButton(
                text: "Forgot your password ?",
                press: () {
                  Navigator.of(context)
                      .pushReplacementNamed(PASSWORDRECOVER_SCREEN);
                }),
            SizedBox(
              height: 30.0,
            ),
            LinkButton(
                text: "Don’t have an Account ? Sign up",
                press: () {
                  Navigator.of(context).pushReplacementNamed(SIGNUP_SCREEN);
                }),
          ],
        ),
      ),
    );
  }
}
