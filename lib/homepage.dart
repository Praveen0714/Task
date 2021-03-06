import 'dart:async';
import 'package:demotask/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart'
    show Permission, PermissionActions, PermissionStatus, openAppSettings;
import 'package:shared_preferences/shared_preferences.dart';

import 'locationlist.dart';
// jk

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  double? lat, lng;
  double? lat1,lng1;
  bool isloading = true;
   Timer? timer;
  final database = FirebaseDatabase.instance.reference();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? uid;
  List<Marker> _markers = [];
  String? isenable;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocation();
    getuserid();
    timer = Timer.periodic(Duration(minutes:15), (Timer t) => getlocation());
  }

  getuserid() {
    uid = _auth.currentUser?.uid;
  }
  @override
  Widget build(BuildContext context) {
    isloading == false
        ? _markers.add(Marker(
            markerId: MarkerId('marker1'),
            position: LatLng(lat!, lng!),
            infoWindow: InfoWindow(title: isenable=="true"?
            'Your pinned location is here':"Your current location is here")))
        : SizedBox();
    return Scaffold(
      body: isloading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : Stack(children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  children: [
                    Expanded(
                      child: GoogleMap(
                          myLocationButtonEnabled: true,
                          // myLocationEnabled: true,
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: true,
                          onMapCreated: (GoogleMapController controller) async {
                            _controllerGoogleMap.complete(controller);
                            mapController = controller;
                          },
                          initialCameraPosition:
                           isenable=="true"? CameraPosition(
                                  target: LatLng(lat1!, lng1!), zoom: 20.0):
                          CameraPosition(
                              target: LatLng(lat!, lng!), zoom: 20.0),
                          markers: Set<Marker>.of(_markers)),
                    ),
                  ],
                ),
              ),
            ]),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => locationlist()));
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.list,
              size: 25,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              _auth.signOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => login()));
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.logout,
              size: 25,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10,),
          FloatingActionButton(
            onPressed: () async{
              SharedPreferences prefs=await SharedPreferences.getInstance();
              prefs.remove("isenable");
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => homepage()));
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.location_on,
              size: 25,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getlocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Position position = await _getGeoLocationPosition();
    lat = position.latitude;
    lng = position.longitude;
    isenable= prefs.getString("isenable");
    if(isenable!="true") {
      String? childnode = position.hashCode.toString();
      setState(() {
        database.child("Location").child(uid.toString()).child(childnode).set({
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
      });
    }
    setState(() {
      if(isenable=="true") {
        lat1 = prefs.getDouble("lat");
        lng1 = prefs.getDouble("lng");
      }
      isloading = false;
    });
  }
}
