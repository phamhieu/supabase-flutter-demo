import 'package:demoapp/components/auth_state.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/screens/profile_screen.dart';
import 'package:demoapp/utils/constants.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:supabase/supabase.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends AuthState<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final RoundedLoadingButtonController _signInEmailController =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _magicLinkController =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _githubSignInController =
      RoundedLoadingButtonController();

  String _email = '';
  String _password = '';

  @override
  void onErrorAuthenticating(String message) {
    showMessage(message);
    _githubSignInController.reset();
  }

  void _onSignInPress(BuildContext context) async {
    final form = formKey.currentState;

    if (form != null && form.validate()) {
      form.save();
      FocusScope.of(context).unfocus();

      final response = await Supabase()
          .client
          .auth
          .signIn(email: _email, password: _password);
      if (response.error != null) {
        showMessage(response.error!.message);
        _signInEmailController.reset();
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
    } else {
      _signInEmailController.reset();
    }
  }

  void _onMagicLinkPress(BuildContext context) async {
    final form = formKey.currentState;

    if (form != null && form.validate()) {
      form.save();
      FocusScope.of(context).unfocus();

      final response = await Supabase().client.auth.signIn(
            email: _email,
            options: supabase.AuthOptions(
              redirectTo: AUTH_REDIRECT_URI,
            ),
          );
      if (response.error != null) {
        showMessage(response.error!.message);
        _magicLinkController.reset();
      } else {
        showMessage('Check your email for the login link!');
      }
    } else {
      _magicLinkController.reset();
    }
  }

  void _githubSigninPressed(BuildContext context) async {
    FocusScope.of(context).unfocus();

    await Supabase().client.auth.signInWithProvider(
          supabase.Provider.github,
          options: supabase.AuthOptions(
            redirectTo: AUTH_REDIRECT_URI,
          ),
        );
  }

  void showMessage(String message) {
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 25.0),
              TextFormField(
                onSaved: (value) => _email = value ?? '',
                validator: (val) => !EmailValidator.validate(val ?? '', true)
                    ? 'Not a valid email.'
                    : null,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                ),
              ),
              SizedBox(height: 15.0),
              TextFormField(
                onSaved: (value) => _password = value ?? '',
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
              SizedBox(height: 15.0),
              RoundedLoadingButton(
                color: Colors.green,
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                controller: _signInEmailController,
                onPressed: () {
                  _onSignInPress(context);
                },
              ),
              SizedBox(height: 15.0),
              RoundedLoadingButton(
                color: Colors.green,
                child: const Text(
                  'Send magic link',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                controller: _magicLinkController,
                onPressed: () {
                  _onMagicLinkPress(context);
                },
              ),
              SizedBox(height: 15.0),
              RoundedLoadingButton(
                color: Colors.black,
                child: const Text(
                  'Github Login',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                controller: _githubSignInController,
                onPressed: () {
                  _githubSigninPressed(context);
                },
              ),
              SizedBox(height: 15.0),
              TextButton(
                child: const Text("Forgot your password ?"),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(PASSWORDRECOVER_SCREEN);
                },
              ),
              TextButton(
                child: const Text("Don’t have an Account ? Sign up"),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(SIGNUP_SCREEN);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
