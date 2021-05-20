import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kittinunshoppingmall/screens/myservice.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  //Explicit

  final formKey = GlobalKey<FormState>();
   String emailString, passwordString;

  //Method
  Widget backBtn() {
    return IconButton(
      icon: Icon(
        Icons.navigate_before,
        size: 36.0,
        color: Colors.orange.shade900,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget content() {
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            showAppName(),
            SizedBox(
              height: 8.0,
            ),
            emailText(),
            paawordText(),
          ],
        ),
      ),
    );
  }

  Widget showAppName() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [showLogo(), showText()],
    );
  }

  Widget showLogo() {
    return Container(
        width: 48.0, height: 48.0, child: Image.asset('images/logo.png'));
  }

  Widget showText() {
    return Text(
      'Kittinun shopping mall',
      style: TextStyle(
          fontSize: 24.0,
          color: Colors.orange.shade900,
          fontWeight: FontWeight.bold,
          // fontStyle: FontStyle.italic,
          fontFamily: 'Pangolin-Regular'),
    );
  }

  Widget emailText() {
    return Container(
        width: 350.0,
        height: 56.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(2.0),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            hintText: 'Email',
            prefix: Container(
              width: 36,
              //height: 18,
              margin: const EdgeInsets.only(
                right: 5.0,
                //left: 5.0,
              ),
              padding: const EdgeInsets.all(2.0),
            ),
            icon: Icon(
              Icons.email,
              color: Colors.orange.shade900,
              size: 29.0,
            ),
            labelText: 'Email: ',
            labelStyle: TextStyle(
                color: Colors.orange.shade900, fontWeight: FontWeight.bold),
            //helperText: 'Type your Email',
            //helperStyle: TextStyle(color: Colors.orange.shade900),
          ),
          onSaved: (value) {
            emailString = value.trim();
          },
        ));
  }

  Widget paawordText() {
    return Container(
        width: 350.0,
        height: 56.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(2.0),
        child: TextFormField(
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            hintText: 'Password',
            prefix: Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(
                right: 5.0,
                //left: 5.0,
              ),
              padding: const EdgeInsets.all(2.0),
              decoration: const BoxDecoration(),
            ),
            icon: Icon(
              Icons.lock,
              color: Colors.orange.shade900,
              size: 29.0,
            ),
            labelText: 'Password: ',
            labelStyle: TextStyle(
                color: Colors.orange.shade900, fontWeight: FontWeight.bold),
            //helperText: 'Type your Email',
            //helperStyle: TextStyle(color: Colors.orange.shade900),
          ),
          onSaved: (value) {
            passwordString = value.trim();
          },
        ));
  }

  Future checkAuthen() async {
    await Firebase.initializeApp();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .signInWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((response) {
      print('Authen success');
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => MyService());
      Navigator.of(context).pushAndRemoveUntil(materialPageRoute,
          (route) => false); /*delete this page and route that page*/
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      myAlert(title, message);
    });
  }

  Widget showTitle(String title) {
    return ListTile(
      leading: Icon(
        Icons.add_alert,
        size: 48.0,
        color: Colors.orange.shade900,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: Colors.orange.shade900,
            fontSize: 18.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget okBtn() {
    return FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: showTitle(title),
            content: Text(message),
            actions: [okBtn()],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // decoration: BoxDecoration(
          //     gradient:
          //         RadialGradient(colors: [Colors.white,Colors.teal.shade100], radius: 1.0)),
          child: Stack(
            children: [
              backBtn(),
              content(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade900,
        child: Icon(
          Icons.navigate_next,
          size: 36.0,
        ),
        onPressed: () {
          formKey.currentState.save();
          print('email = $emailString, password = $passwordString');
          checkAuthen();
        },
      ),
    );
  }
}
