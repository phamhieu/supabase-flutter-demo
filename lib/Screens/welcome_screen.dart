import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotrue/gotrue.dart';
import 'package:demoapp/Screens/signin_screen.dart';
import 'package:demoapp/components/alert_modal.dart';
import 'package:demoapp/constants.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  final String _appBarTitle;

  WelcomeScreen(this._appBarTitle, {Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState(_appBarTitle);
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final RoundedLoadingButtonController _signOutBtnController =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _updateProfileBtnController =
      new RoundedLoadingButtonController();
  final String _appBarTitle;

  User? user;
  bool loadingProfile = true;
  String username = '';
  String website = '';
  String avatarUrl = '';

  _WelcomeScreenState(this._appBarTitle);

  @override
  void initState() {
    super.initState();

    final clientUser = supabaseClient.auth.user();
    if (clientUser != null) {
      setState(() {
        user = clientUser;
      });
      loadProfile(clientUser.id);
    }
  }

  void loadProfile(String userId) async {
    final response = await supabaseClient
        .from('profiles')
        .select('username, website, avatar_url')
        .eq('id', userId)
        .single()
        .execute();
    if (response.error == null && response.data != null) {
      print(response.data);
      setState(() {
        username = response.data['username'] ?? '';
        website = response.data['website'] ?? '';
        avatarUrl = response.data['avatar_url'] ?? '';
        loadingProfile = false;
      });
    }
  }

  void _onSignOutPress(BuildContext context) async {
    await supabaseClient.auth.signOut();

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

  void _onUpdateProfilePress(BuildContext context) async {
    final updates = {
      'id': user?.id,
      'username': username,
      'website': website,
      'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toString(),
    };

    final response =
        await supabaseClient.from('profiles').upsert(updates).execute();
    if (response.error != null) {
      alertModal.show(context,
          title: 'Update profile failed', message: response.error!.message);
    }

    _updateProfileBtnController.reset();
    Fluttertoast.showToast(msg: "profile updated", fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    if (loadingProfile) {
      return Scaffold(
        appBar: AppBar(
          title: Text(this._appBarTitle),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height / 1.3,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
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
              TextFormField(
                onChanged: (value) => setState(() {
                  username = value;
                }),
                initialValue: username,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: '',
                ),
              ),
              TextFormField(
                onChanged: (value) => setState(() {
                  website = value;
                }),
                initialValue: website,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Website',
                  hintText: '',
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
              RoundedLoadingButton(
                color: Colors.green,
                child: Text('Update profile',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                controller: _updateProfileBtnController,
                onPressed: () {
                  _onUpdateProfilePress(context);
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              RoundedLoadingButton(
                color: Colors.red,
                child: Text('Sign out',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                controller: _signOutBtnController,
                onPressed: () {
                  _onSignOutPress(context);
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}
