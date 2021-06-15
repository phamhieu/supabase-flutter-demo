import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gotrue/gotrue.dart';
import 'package:demoapp/constants.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  User? user;

  @override
  void initState() {
    super.initState();

    setState(() {
      final clientUser = supabaseClient.auth.user();
      if (clientUser != null) user = clientUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: randomCenter(),
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: Text('Stop!'),
        icon: Icon(Icons.dangerous),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  LatLng randomCenter() {
    var list = [
      LatLng(1.3489728457596013, 103.77043978311998),
      LatLng(1.37462, 103.77694),
      LatLng(1.41006, 103.77144),
      LatLng(1.34313, 103.84191),
      LatLng(1.35454, 103.69746),
    ];
    final _random = new Random();
    return list[_random.nextInt(list.length)];
  }
}
