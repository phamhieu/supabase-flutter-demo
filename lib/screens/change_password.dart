import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/components/auth_required_state.dart';
import '/utils/helpers.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends AuthRequiredState<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _passwordField = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  String _password = '';

  Future _onPasswordChangePress(BuildContext context) async {
    try {
      final form = formKey.currentState;

      if (form != null && form.validate()) {
        form.save();
        FocusScope.of(context).unfocus();

        final userAttributes = UserAttributes(password: _password);
        final response =
            await Supabase.instance.client.auth.update(userAttributes);
        if (response.error != null) {
          throw 'Password change failed: ${response.error!.message}';
        }

        showMessage('Password updated');
        if (Navigator.canPop(context)) {
          _btnController.success();
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/profile',
            (route) => false,
          );
        }
      }
    } catch (e) {
      showMessage(e.toString());
    } finally {
      _btnController.reset();
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
        title: const Text('Change password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 25.0),
              TextFormField(
                onSaved: (value) => _password = value ?? '',
                validator: (val) => validatePassword(val),
                controller: _passwordField,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                validator: (val) =>
                    val != _passwordField.text ? 'Not Match' : null,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Confirm password',
                ),
              ),
              const SizedBox(height: 15.0),
              RoundedLoadingButton(
                color: Colors.green,
                controller: _btnController,
                onPressed: () {
                  _onPasswordChangePress(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
