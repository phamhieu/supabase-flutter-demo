import 'package:flutter/material.dart';
import 'package:gotrue/gotrue.dart';
import 'package:demoapp/Screens/Signin/signin_screen.dart';
import 'package:demoapp/components/alert_modal.dart';
import 'package:demoapp/constants.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  final String _appBarTitle;

  WelcomeScreen(this._appBarTitle, {Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState(_appBarTitle);
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final String _appBarTitle;
  User user;

  _WelcomeScreenState(this._appBarTitle);

  @override
  void initState() {
    super.initState();

    setState(() {
      final clientUser = supabaseClient.auth.user();
      if (clientUser != null) user = clientUser;
    });
  }

  void _onSignOutPress(BuildContext context) async {
    final response = await supabaseClient.auth.signOut();
    if (response.error != null) {
      alertModal.show(context,
          title: 'Sign out failed', message: response.error.message);
      _btnController.reset();
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(PERSIST_SESSION_KEY);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SignInScreen();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this._appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 25.0),
            Text(
              user?.toJson().toString() ?? 'Loading user...',
            ),
            SizedBox(
              height: 35.0,
            ),
            RoundedLoadingButton(
              child: Text('Sign out',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              controller: _btnController,
              onPressed: () {
                _onSignOutPress(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
