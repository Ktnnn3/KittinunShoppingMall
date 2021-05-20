import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kittinunshoppingmall/screens/authen.dart';
import 'package:kittinunshoppingmall/screens/myservice.dart';
import 'package:kittinunshoppingmall/screens/register.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //method

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  Future<void> checkStatus() async {
    await Firebase.initializeApp();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    if (user != null) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => MyService());
      Navigator.of(context)
          .pushAndRemoveUntil(materialPageRoute, (route) => false);
    }
  }

  Widget showLogo() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'Kittinun Shopping Mall',
      style: TextStyle(
          fontSize: 30.0,
          color: Colors.orange.shade900,
          fontWeight: FontWeight.bold,
          // fontStyle: FontStyle.italic,
          fontFamily: 'Pangolin-Regular'),
    );
  }

  Widget signInBtn() {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      //color: Colors.teal.shade400,
      color: Colors.orange.shade900,
      child: Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Authen());
            Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget signUpBtn() {
    // ignore: deprecated_member_use
    // return OutlineButton(
    //   child: Text('Sign Up'),
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      //color: Colors.teal.shade400,
      color: Colors.orange.shade900,
      child: Text(
        'Sign Up',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        print('you click sign up');

        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Register());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        signInBtn(),
        SizedBox(
          width: 8.0,
        ),
        signUpBtn(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(color: Colors.white
            //     gradient: RadialGradient(
            //   colors: [Colors.white, Colors.teal.shade500],
            //   radius: 1.0,
            // )
            ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              showLogo(),
              SizedBox(
                height: 8.0,
              ),
              showAppName(),
              showButton()
            ],
          ),
        ),
      )),
    );
  }
}
