import 'package:demotask/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class locationlist extends StatefulWidget {
  const locationlist({Key? key}) : super(key: key);

  @override
  State<locationlist> createState() => _locationlistState();
}

class _locationlistState extends State<locationlist> {
  List<Modal> _list = [];
  final database = FirebaseDatabase.instance.reference().child("Location");
  bool isloading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlistdata();
  }

  getlistdata() {
    String? uid = _auth.currentUser?.uid;
    database.child(uid.toString()).once().then((DataSnapshot snapchat) {
      var data = snapchat.value;
      _list.clear();
      data.forEach((key, value) {
        Modal modal =
            Modal(latitude: value['latitude'], longitude: value['longitude']);
        _list.add(modal);
        print("My length= ${_list.length}");
      });
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location List"),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: _list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () async{
                               SharedPreferences prefs=await SharedPreferences.getInstance();
                               prefs.setDouble("lat",_list[index].latitude);
                               prefs.setDouble("lng",_list[index].longitude);
                                prefs.setString("isenable","true");
                                 Navigator.push(context,
                                     MaterialPageRoute(builder: (context) => homepage()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text("Latitude:"),
                                            Text(_list[index]
                                                .latitude
                                                .toString())
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Row(
                                          children: [
                                            Text("Longitude:"),
                                            Text(_list[index]
                                                .longitude
                                                .toString())
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ));
                        }))
              ],
            ),
    );
  }
}

class Modal {
  double latitude;
  double longitude;

  Modal({required this.latitude, required this.longitude});
}
