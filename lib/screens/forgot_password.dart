import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:supabase/supabase.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart';

import '/components/auth_state.dart';
import '/utils/helpers.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends AuthState<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  String _email = '';

  Future _onPasswordRecoverPress(BuildContext context) async {
    final form = formKey.currentState;

    if (form != null && form.validate()) {
      form.save();
      FocusScope.of(context).unfocus();

      final response = await Supabase.instance.client.auth.api
          .resetPasswordForEmail(_email,
              options: supabase.AuthOptions(redirectTo: authRedirectUri));
      if (response.error != null) {
        showMessage('Password recovery failed: ${response.error!.message}');
        _btnController.reset();
      } else {
        showMessage('Please check your email for further instructions.');
        _btnController.success();
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
        title: const Text('Forgot password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 25.0),
              TextFormField(
                onSaved: (value) => _email = value ?? '',
                validator: (val) => validateEmail(val),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email address',
                ),
              ),
              const SizedBox(height: 35.0),
              RoundedLoadingButton(
                color: Colors.green,
                controller: _btnController,
                onPressed: () {
                  _onPasswordRecoverPress(context);
                },
                child: const Text(
                  'Send reset password instructions',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
