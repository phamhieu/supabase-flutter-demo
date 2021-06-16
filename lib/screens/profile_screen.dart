import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:demoapp/components/lifecycle_state.dart';
import 'package:demoapp/utils/supabase.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotrue/gotrue.dart';
import 'package:demoapp/screens/signin_screen.dart';
import 'package:demoapp/components/alert_modal.dart';
import 'package:path/path.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen(this._appBarTitle, {Key? key}) : super(key: key);

  final String _appBarTitle;

  @override
  _ProfileScreenState createState() => _ProfileScreenState(_appBarTitle);
}

class _ProfileScreenState extends LifecycleState<ProfileScreen> {
  _ProfileScreenState(this._appBarTitle);

  final RoundedLoadingButtonController _signOutBtnController =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _updateProfileBtnController =
      new RoundedLoadingButtonController();
  final String _appBarTitle;

  final _picker = ImagePicker();

  User? user;
  bool loadingProfile = true;
  String username = '';
  String website = '';
  String avatarUrl = '';

  @override
  void initState() {
    super.initState();

    final clientUser = Supabase.client.auth.user();
    if (clientUser != null) {
      setState(() {
        user = clientUser;
      });
      loadProfile(clientUser.id);
    }
  }

  void loadProfile(String userId) async {
    final response = await Supabase.client
        .from('profiles')
        .select('username, website, avatar_url')
        .eq('id', userId)
        .single()
        .execute();
    if (response.error == null && response.data != null) {
      setState(() {
        username = response.data['username'] ?? '';
        website = response.data['website'] ?? '';
        avatarUrl = response.data['avatar_url'] ?? '';
        loadingProfile = false;
      });
    }
  }

  final picker = ImagePicker();

  Future updateAvatar(BuildContext context) async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileExt = extension(file.path);
      final fileName = '${getRandomStr(15)}$fileExt';

      final response =
          await Supabase.client.storage.from('avatars').upload(fileName, file);
      if (response.error == null) {
        setState(() {
          avatarUrl = fileName;
        });
        _onUpdateProfilePress(context);
      } else {
        print(response.error!.message);
      }
    }
  }

  void _onSignOutPress(BuildContext context) async {
    await Supabase.client.auth.signOut();

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
        await Supabase.client.from('profiles').upsert(updates).execute();
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(this._appBarTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              AvatarContainer(avatarUrl, key: Key(avatarUrl)),
              ElevatedButton(
                child: Text('Change avatar',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: () => updateAvatar(context),
              ),
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

class AvatarContainer extends StatefulWidget {
  AvatarContainer(this.url, {Key? key}) : super(key: key);

  final String url;

  @override
  _AvatarContainerState createState() => _AvatarContainerState(url);
}

class _AvatarContainerState extends State<AvatarContainer> {
  _AvatarContainerState(this.url);

  final String url;
  Uint8List? image;

  @override
  void initState() {
    super.initState();

    if (url != '') {
      downloadImage(url);
    }
  }

  void downloadImage(String path) async {
    final response =
        await Supabase.client.storage.from('avatars').download(path);
    if (response.error == null) {
      setState(() {
        image = response.data;
      });
    } else {
      print(response.error!.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Container(
        width: 125,
        height: 125,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/noavatar.jpeg'),
          ),
        ),
      );
    } else {
      return Container(
        width: 125,
        height: 125,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: MemoryImage(image!),
          ),
        ),
      );
    }
  }
}

String getRandomStr(int length) {
  const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  Random r = Random();
  return String.fromCharCodes(
      Iterable.generate(length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
}
