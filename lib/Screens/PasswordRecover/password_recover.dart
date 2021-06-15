import 'package:demoapp/components/alert_modal.dart';
import 'package:demoapp/components/link_button.dart';
import 'package:demoapp/components/rounded_input_field.dart';
import 'package:demoapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class PasswordRecoverScreen extends StatefulWidget {
  PasswordRecoverScreen({Key? key}) : super(key: key);

  @override
  _PasswordRecoverState createState() => _PasswordRecoverState();
}

class _PasswordRecoverState extends State<PasswordRecoverScreen> {
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  var email = '';

  void _onPasswordRecoverPress(BuildContext context) async {
    final response = await supabaseClient.auth.api.resetPasswordForEmail(email);
    if (response.error != null) {
      alertModal.show(context,
          title: 'Send password recovery failed',
          message: response.error!.message);
      _btnController.reset();
    } else {
      alertModal.show(context,
          title: 'Password recovery email sent',
          message: 'Please check your email for further instructions.');
      _btnController.success();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot password'),
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
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            SizedBox(
              height: 35.0,
            ),
            RoundedLoadingButton(
              child: Text('Send reset password instructions',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              controller: _btnController,
              onPressed: () {
                _onPasswordRecoverPress(context);
              },
            ),
            SizedBox(
              height: 35.0,
            ),
            LinkButton(
                text: "Go back to sign in",
                press: () {
                  Navigator.of(context).pushReplacementNamed(SIGNIN_SCREEN);
                }),
          ],
        ),
      ),
    );
  }
}
