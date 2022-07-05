import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'homepage.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController email=TextEditingController();
  TextEditingController pw=TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((value){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => homepage()));
      });
      return null;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: "Error:$e",toastLength: Toast.LENGTH_LONG);
      return e.message;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        centerTitle:true,
        title: Text("LOGIN",style: TextStyle(fontSize:20),
        ),
      ),
      body:SingleChildScrollView(child:
      Padding(
        padding: const EdgeInsets.only(top:50,left:20,right: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius:80,
              child: Icon(Icons.login,size:50,),
            ),
            SizedBox(height:20,),
            Text("LOGIN",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            Padding(
              padding: const EdgeInsets.only(top:20),
              child: TextField(
                controller:email,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:"Email",
                  filled: true,
                  fillColor: Colors.grey.shade200
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20),
              child: TextField(
                controller:pw,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:"Password",
                    filled: true,
                    fillColor: Colors.grey.shade200
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20),
              child: RaisedButton(color: Colors.orange,
                onPressed:(){
                  if(email.text.isNotEmpty && pw.text.isNotEmpty) {
                    signIn(email: email.text, password: pw.text);
                  }else{
                    Fluttertoast.showToast(
                        msg: "Please enter email and password",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 5);
                  }
              },
                child:Text("Login",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize:20),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:100),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(
                    'Don\'t have an account ?',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => signup()));
                    },
                  child:Text(
                    'Register',
                    style: TextStyle(
                        color: Color(0xfff79c4f),
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),)
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}



class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController email=TextEditingController();
  TextEditingController pw=TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final database = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("SIGNUP",style: TextStyle(fontSize:20),
        ),
      ),
      body:SingleChildScrollView(child:
      Padding(
        padding: const EdgeInsets.only(top:50,left:20,right: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius:80,
              child: Icon(Icons.app_registration,size:50,),
            ),
            SizedBox(height:20,),
            Text("SIGNUP",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            Padding(
              padding: const EdgeInsets.only(top:20),
              child: TextField(
                controller:email,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:"Email",
                    filled: true,
                    fillColor: Colors.grey.shade200
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20),
              child: TextField(
                controller:pw,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:"Password",
                    filled: true,
                    fillColor: Colors.grey.shade200
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20),
              child: RaisedButton(color: Colors.orange,
                onPressed:(){
                if(email.text.isNotEmpty && pw.text.isNotEmpty) {
                  signUp(email: email.text, password: pw.text);
                }else{
                  Fluttertoast.showToast(
                      msg: "Please enter email and password",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 5);
                }
                },
                child:Text("SIGNUP",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize:20),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:100),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(
                    'Already have an account ?',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => login()));
                    },
                    child:Text(
                      'Register',
                      style: TextStyle(
                          color: Color(0xfff79c4f),
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),)
                ],
              ),
            ),
          ],
        ),
      ),
      ));
  }

  Future signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) {
        String? uid=_auth.currentUser?.uid;
        database.child("Login_Details").child(uid.toString()).set({
          'email':email,
          'password':password,
        }).then((result) {
          Fluttertoast.showToast(
              msg: "Registered Successfully!...",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5);
          Navigator.push(context, MaterialPageRoute(builder: (context) =>login()))
              .catchError((onError) {
            Fluttertoast.showToast(
                msg: "Registration failed....",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5);
          });
        });
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}

