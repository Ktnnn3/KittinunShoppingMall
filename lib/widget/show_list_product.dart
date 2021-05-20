import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kittinunshoppingmall/product_model.dart';

class ShowListProduct extends StatefulWidget {
  @override
  _ShowListProductState createState() => _ShowListProductState();
}

class _ShowListProductState extends State<ShowListProduct> {
  //Field
  List<ProductModel> productModels = [];
  String initialURL =
      'https://firebasestorage.googleapis.com/v0/b/kittinunshoppingmall.appspot.com/o/Product%2Fflat-square-icon-a-cute-crocodile-vector-6377595.jpg?alt=media&token=bc687a61-e213-4ddf-b712-13d8870993a8';

  //Method
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllData();
  }

  Future readAllData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Product');
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.docs;
      for (var snapshot in snapshots) {
        print('Name = ${snapshot.get('Name')}');

        ProductModel productModel = ProductModel.fromMap(snapshot.data());
        setState(() {
          productModels.add(productModel);
        });
      }
    });
  }

  Widget showListView(int index) {
    return Row(
      children: [
        showImage(index),
        showText(index),
      ],
    );
  }

  Widget nullImageProblem() {
    return Text("Don't know");
  }

  Widget showImage(int index) {
    return Container(
        padding: EdgeInsets.all(30.0),
        width: MediaQuery.of(context).size.width * 0.5,
        // MediaQuery.of(context).size.width = หาขนาดของจอทั้งหมด
        height: MediaQuery.of(context).size.width * 0.5,

        // ignore: unnecessary_null_comparison
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                // ignore: unnecessary_null_comparison
                image: NetworkImage(productModels[index].pathImage == null
                    ? initialURL
                    : productModels[index].pathImage),
                fit: BoxFit.cover,
              )),
        )
        // Image.network(productModels[index].pathImage == null
        // ? initialURL
        // : productModels[index].pathImage)
        //Image.network(productModels[index].pathImage),
        );
  }

  Widget showName(int index) {
    return Row(
      // right //mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          productModels[index].name,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade900,
          ),
        ),
      ],
    );
  }

  Widget showDetial(int index) {
    String string = productModels[index].detail;
    //ตัดคำ
    if (string.length > 100) {
      string = string.substring(0, 99);
      string = '$string...';
    }
    return Text(
      string,
      style: TextStyle(
        fontSize: 15.0,
        fontStyle: FontStyle.italic,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget showText(int index) {
    return Container(
      padding: EdgeInsets.only(top: 30.0, right: 20.0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        //แยกบนล่าง //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          showName(index),
          SizedBox(
            height: 6.0,
          ),
          showDetial(index),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: productModels.length,
        itemBuilder: (BuildContext buildContext, int index) {
          return showListView(index);
        },
      ),
    );
  }
}
