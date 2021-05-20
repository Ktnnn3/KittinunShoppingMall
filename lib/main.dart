// @dart=2.9
import 'package:flutter/material.dart';
import 'package:kittinunshoppingmall/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( title:'Kittinun ShoppingMall' ,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: Home(),
    );
  }
}
