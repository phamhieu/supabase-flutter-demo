import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gotrue/gotrue.dart';
import 'package:path/path.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _ProfileScreenState();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final RoundedLoadingButtonController _signOutBtnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _updateProfileBtnController =
      RoundedLoadingButtonController();

  final _picker = ImagePicker();

  User? user;
  bool loadingProfile = true;
  String _appBarTitle = '';
  String username = '';
  String website = '';
  String avatarUrl = '';

  @override
  void initState() {
    super.initState();

    final _user = Supabase().client.auth.user();
    if (_user != null) {
      setState(() {
        _appBarTitle = 'Welcome ${_user.email}';
        user = _user;
      });
      loadProfile(_user.id);
    }
  }

  Future<bool> loadProfile(String userId) async {
    final response = await Supabase()
        .client
        .from('profiles')
        .select('username, website, avatar_url')
        .eq('id', userId)
        .single()
        .execute();
    if (response.error == null && response.data != null) {
      setState(() {
        username = response.data['username'] as String? ?? '';
        website = response.data['website'] as String? ?? '';
        avatarUrl = response.data['avatar_url'] as String? ?? '';
        loadingProfile = false;
      });
    } else {
      setState(() {
        loadingProfile = false;
      });
    }
    return true;
  }

  final picker = ImagePicker();

  Future updateAvatar(BuildContext context) async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileExt = extension(file.path);
      final fileName = '${getRandomStr(15)}$fileExt';

      final response = await Supabase()
          .client
          .storage
          .from('avatars')
          .upload(fileName, file);
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

  Future<bool> _onSignOutPress(BuildContext context) async {
    await Supabase().client.auth.signOut();
    Navigator.pushReplacementNamed(context, '/signIn');
    return true;
  }

  Future<bool> _onUpdateProfilePress(BuildContext context) async {
    final updates = {
      'id': user?.id,
      'username': username,
      'website': website,
      'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toString(),
    };

    final response =
        await Supabase().client.from('profiles').upsert(updates).execute();
    if (response.error != null) {
      showMessage("Update profile failed: ${response.error!.message}");
      _updateProfileBtnController.reset();
      return false;
    } else {
      _updateProfileBtnController.reset();
      showMessage("Profile updated!");
      return true;
    }
  }

  void showMessage(String message) {
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    if (loadingProfile) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_appBarTitle),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height / 1.3,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(_appBarTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              AvatarContainer(avatarUrl, key: Key(avatarUrl)),
              ElevatedButton(
                onPressed: () => updateAvatar(context),
                child: const Text('Change avatar',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
              TextFormField(
                onChanged: (value) => setState(() {
                  username = value;
                }),
                initialValue: username,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
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
                decoration: const InputDecoration(
                  labelText: 'Website',
                  hintText: '',
                ),
              ),
              const SizedBox(
                height: 35.0,
              ),
              RoundedLoadingButton(
                color: Colors.green,
                controller: _updateProfileBtnController,
                onPressed: () {
                  _onUpdateProfilePress(context);
                },
                child: const Text('Update profile',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
              const SizedBox(height: 15.0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile/changePassword');
                },
                child: const Text("Change password"),
              ),
              const Expanded(child: SizedBox()),
              RoundedLoadingButton(
                color: Colors.red,
                controller: _signOutBtnController,
                onPressed: () {
                  _onSignOutPress(context);
                },
                child: const Text('Sign out',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class AvatarContainer extends StatefulWidget {
  final String url;
  const AvatarContainer(this.url, {Key? key}) : super(key: key);

  @override
  _AvatarContainerState createState() => _AvatarContainerState();
}

class _AvatarContainerState extends State<AvatarContainer> {
  _AvatarContainerState();

  Uint8List? image;

  @override
  void initState() {
    super.initState();

    if (widget.url != '') {
      downloadImage(widget.url);
    }
  }

  Future<bool> downloadImage(String path) async {
    final response =
        await Supabase().client.storage.from('avatars').download(path);
    if (response.error == null) {
      setState(() {
        image = response.data;
      });
      return true;
    } else {
      print(response.error!.message);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Container(
        width: 125,
        height: 125,
        decoration: const BoxDecoration(
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
  final Random r = Random();
  return String.fromCharCodes(
      Iterable.generate(length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
}
