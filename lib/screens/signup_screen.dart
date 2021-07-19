import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:supabase/supabase.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart';

import '/components/auth_state.dart';
import '/utils/helpers.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends AuthState<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  String _email = '';
  String _password = '';

  Future _onSignUpPress(BuildContext context) async {
    final form = formKey.currentState;

    if (form != null && form.validate()) {
      form.save();
      FocusScope.of(context).unfocus();

      final response = await Supabase.instance.client.auth.signUp(
          _email, _password,
          options: supabase.AuthOptions(redirectTo: authRedirectUri));
      if (response.error != null) {
        showMessage('Sign up failed: ${response.error!.message}');
        _btnController.reset();
      } else if (response.data == null && response.user == null) {
        showMessage(
            "Please check your email and follow the instructions to verify your email address.");
        _btnController.success();
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/profile',
          (route) => false,
        );
      }
    }
  }

  void showMessage(String message) {
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 15.0),
              TextFormField(
                onSaved: (value) => _email = value ?? '',
                validator: (val) => validateEmail(val),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email address',
                ),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                onSaved: (value) => _password = value ?? '',
                validator: (val) => validatePassword(val),
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 15.0),
              RoundedLoadingButton(
                color: Colors.green,
                controller: _btnController,
                onPressed: () {
                  _onSignUpPress(context);
                },
                child: const Text(
                  'Sign up',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
