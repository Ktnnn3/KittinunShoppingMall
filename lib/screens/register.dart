import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kittinunshoppingmall/screens/myservice.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Explicit
  final formKey = GlobalKey<FormState>(); //go to Listview
  String nameSttring, emailString, passwordString;

  //Method
  Widget registerBtn() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('you click Upload');
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print(
              'name = $nameSttring, email = $emailString, password = $passwordString');
          registerThread();
        }
      },
    );
  }

  Future<void> registerThread() async {
    await Firebase.initializeApp();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((response) {
      print('Register success for Email = $emailString');
      setupDisplayName();
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      print('title = $title, message = $message');
      myAlert(title, message);
    });
  }

  Future setupDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    user.updateProfile(displayName: nameSttring);

    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) => MyService());
    Navigator.of(context)
        .pushAndRemoveUntil(materialPageRoute, (Route<dynamic> route) => false);
    //push as no return
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: ListTile(
              leading: Icon(
                Icons.add_alert,
                color: Colors.red,
                size: 48.0,
              ),
              title: Text(
                title,
                style: TextStyle(color: Colors.red),
              ),
            ),
            content: Text(message),
            /*button*/ actions: [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget nameText() {
    return Container(
      height: 70.0,
      // padding: const EdgeInsets.all(8.0),
      //   margin: const EdgeInsets.all(2.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black, fontSize: 20.0),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(18.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
          hintText: 'Name',
          prefix: Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(
                right: 8.0,
              ),
              padding: const EdgeInsets.all(8.0)
              // decoration: const BoxDecoration(
              //     border: Border(
              //         right: BorderSide(width: 1.0, color: Color(0xAAAA000000)))),
              ),
          icon: Icon(
            Icons.face,
            color: Colors.orange.shade900,
            size: 48.0,
          ),
          labelText: 'Display Name: ',
          labelStyle: TextStyle(
              color: Colors.orange.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 14.0),
          helperText: 'Type your nickname for display',
          helperStyle: TextStyle(color: Colors.orange.shade900),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please Fill Your Name in the Blank';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          nameSttring = value.trim();
        },
      ),
    );
  }

  Widget emailText() {
    return Container(
      height: 70.0,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: Colors.black, fontSize: 20.0),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
          hintText: 'Email',
          prefix: Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(
              right: 8.0,
            ),
            padding: const EdgeInsets.all(8.0),
            // decoration: const BoxDecoration(
            //     border: Border(
            //         right: BorderSide(width: 1.0, color: Color(0xAAAA000000)))),
          ),
          icon: Icon(
            Icons.email,
            color: Colors.orange.shade900,
            size: 48.0,
          ),
          labelText: 'Email: ',
          labelStyle: TextStyle(
              color: Colors.orange.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 14.0),
          helperText: 'Type your Email',
          helperStyle: TextStyle(color: Colors.orange.shade900),
        ),
        validator: (value) {
          if (!((value.contains('@')) && (value.contains('.')))) {
            return 'Please Type Email Ex. you@email.com';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          emailString = value.trim();
        },
      ),
    );
  }

  Widget passwordText() {
    return Container(
      height: 70.0,
      child: TextFormField(
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(color: Colors.black, fontSize: 20.0),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
          hintText: 'Password',
          prefix: Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(
              right: 8.0,
            ),
            padding: const EdgeInsets.all(8.0),
            // decoration: const BoxDecoration(
            //     border: Border(
            //         right: BorderSide(
            //   width: 1.0,
            //   color: Color(0xAAAA000000),
            // ))),
          ),
          icon: Icon(
            //Icons.password,
            Icons.lock,
            color: Colors.orange.shade900,
            size: 48.0,
          ),
          labelText: 'Password : ',
          labelStyle: TextStyle(
              color: Colors.orange.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 14.0),
          helperText: 'Type your Password more 6 charactors',
          helperStyle: TextStyle(color: Colors.orange.shade900),
        ),
        validator: (value) {
          if (value.length < 6) {
            return 'Password more 6 Charactor';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          passwordString = value.trim();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Text('Register'),
        actions: <Widget>[registerBtn()],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        /*สกอร์หน้า*/ child: Form(
          key: formKey, //เก็บค่าไป formkey
          child: ListView(
            padding: EdgeInsets.all(30.0),
            children: [
              nameText(),
              SizedBox(
                height: 10.0,
              ),
              emailText(),
              SizedBox(
                height: 10.0,
              ),
              passwordText()
            ],
          ),
        ),
      ),
    );
  }
}
