import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kittinunshoppingmall/screens/home.dart';
import 'package:kittinunshoppingmall/widget/add_list_product.dart';
import 'package:kittinunshoppingmall/widget/show_list_product.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  //Explicit
  String login = '...'; //ค่าเริ่มต้นห้ามเป็น null เป็นช่องว่างได้
  Widget currentWidget = ShowListProduct();

  //Method

  @override
  void initState() {
    super.initState();
    findDisplayName();
  }



  Widget showAddList() {
    return ListTile(
      leading: Icon(
        Icons.playlist_add,
        size: 36.0,
        color: Colors.orange.shade900,
      ),
      title: Text(
        'Add List Product',
        style: TextStyle(color: Colors.orange.shade900, fontSize: 14.0),
      ),
      subtitle: Text('add new product'),
      onTap: () {
        setState(() {
          currentWidget = AddListProduct();
        });
        Navigator.of(context).pop();

      },
    );
  }

  Widget showListProduct() {
    return ListTile(
      leading: Icon(
        Icons.list,
        size: 36.0,
        color: Colors.orange.shade900,
      ),
      title: Text(
        'List Product',
        style: TextStyle(color: Colors.orange.shade900, fontSize: 14.0),
      ),
      subtitle: Text('show all list product'),
      onTap: () {
        setState(() {
          currentWidget = ShowListProduct();
        });
        Navigator.of(context).pop();
      },
    );
  }

  
  Future findDisplayName() async {
    await Firebase.initializeApp();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    setState(() {
      //เพื่อให้มันดึงข้อมูลได้ทัน build วาด
      login = user.displayName;
    });
    print('login = $login');
  }

  Widget showLogo() {
    return Container(
      width: 70.0,
      height: 70.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'Kittinun Shopping Mall',
      style: TextStyle(
          color: Colors.orange.shade900,
          //color: Colors.white,
          fontWeight: FontWeight.bold,
          // fontStyle: FontStyle.italic,
          fontFamily: 'Pangolin-Regular',
          fontSize: 24.0),
    );
  }

  Widget showLogin() {
    return Text(
      'Login by $login',
      //style: TextStyle(color: Colors.white),
    );
  }

  Widget showHead() {
    return DrawerHeader(
      // decoration: BoxDecoration(
      //image: DecorationImage(image: AssetImage("images/shop.jpg"))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showLogo(),
          SizedBox(
            height: 5.0,
          ),
          showAppName(),
          SizedBox(
            height: 6.0,
          ),
          showLogin(),
        ],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: [
          showHead(),
          showListProduct(),
          showAddList(),
        ],
      ),
    );
  }

  Widget signOutBtn() {
    return IconButton(
      icon: Icon(
        Icons.exit_to_app,
      ),
      tooltip: 'Sign Out',
      onPressed: () {
        myAlert();
      },
    );
  }

  Widget cancelBtn() {
    return FlatButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget okBtn() {
    return FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of((context)).pop();
        processSignOut();
      },
    );
  }

  Future processSignOut() async {
    await Firebase.initializeApp();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((response) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Home());
      Navigator.of(context)
          .pushAndRemoveUntil(materialPageRoute, (route) => false);
    });
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure ?'),
            content: Text('Do you want to sign out ?'),
            actions: [cancelBtn(), okBtn()],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Text('My Service'),
        actions: [signOutBtn()],
      ),
      body: currentWidget,
      /*ขีดสามขีด หน้าเมนู*/ drawer: showDrawer(),
    );
  }
}
