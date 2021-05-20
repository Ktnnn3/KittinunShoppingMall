//import 'dart:js';

//import 'dart:html';
import 'dart:io';
import 'dart:math';
//import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:path/path.dart'as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kittinunshoppingmall/screens/myservice.dart';

class AddListProduct extends StatefulWidget {
  @override
  _AddListProductState createState() => _AddListProductState();
}

class _AddListProductState extends State<AddListProduct> {
  //Field

  //เอาFile ที่เป็น dart:io
  //late File file = Image.asset('image/image.png') as File;
  File file;
  //var file = File('null');
  //late ImageSource img;
  String name, detail, urlPic;

  //Method

  Widget uploadBtn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton.icon(
              color: Colors.orange.shade900,
              onPressed: () {
                if (file == null) {
                  showAlert(
                    'Non choose picture',
                    'Please click camera or gallery',
                  );
                  // ignore: unnecessary_null_comparison
                } else if (name == null ||
                    name.isEmpty ||
                    detail == null ||
                    detail.isEmpty) {
                  showAlert(
                    'have space',
                    'please fill every blank',
                  );
                } else {
                  //Upload value to Firebase
                  uploadPictureToStorage();
                }
              },
              icon: Icon(
                Icons.cloud_upload,
                color: Colors.white,
              ),
              label: Text(
                'upload data to Firebase',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Future<void> uploadPictureToStorage() async {
    Random random = Random();
    int i = random.nextInt(100000); // random 5 digits

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference ref = firebaseStorage.ref().child('Product/product$i.jpg');
    UploadTask uploadTask = ref.putFile(file);

    urlPic = await (await uploadTask).ref.getDownloadURL();
    //await แรกค้นหาตน url ก่อน แต่ url จะเกิดจากการอัพโหลดรูปภาพจนเสร็จก่อนแล้วจึงีตัวที่2
    print('urlPic = $urlPic');
    insertValueToFireStore();
  }

  Future<void> insertValueToFireStore() async {
    FirebaseFirestore firebaseStorage = FirebaseFirestore.instance;
    //ข้างหน้าเป็นชื่อ Name ข้างหลังเป็นไรก็ได้
    Map<String, dynamic> map = Map();
    map['Name'] = name;
    map['Detail'] = detail;
    map['PathImage'] = urlPic;

    await firebaseStorage.collection('Product').doc().set(map).then((value) {
      print('Insert success');
      //พออัพเดตเสร็จควรกลับไปที่หน้า showlist
      MaterialPageRoute route =
          MaterialPageRoute(builder: (value) => MyService());
      Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
    });
  }

  Future<void> showAlert(String title, String message) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  Widget DetailForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextField(
        onChanged: (string) {
          detail = string.trim();
        },
        decoration: InputDecoration(
          labelText: 'Detail Product',
          helperText: 'Type your detail of product',
          icon: Icon(Icons.details_rounded),
        ),
      ),
    );
  }

  Widget NameForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextField(
        onChanged: (string) {
          name = string.trim();
        },
        decoration: InputDecoration(
          labelText: 'Name Product',
          helperText: 'Type your name of product',
          icon: Icon(Icons.loyalty),
        ),
      ),
    );
  }

  Widget CameraBtn() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 36.0,
        color: Colors.orange.shade900,
      ),
      onPressed: () {
        chooseImage(ImageSource.camera);
      },
    );
  }

  Future<void> chooseImage(ImageSource img) async {
    try {
      print('first line worked');
      var object = await ImagePicker().getImage(
        source: img,
        maxHeight: 800,
        maxWidth: 800,
      );
      print('second line worked');
      setState(() {
        file = File(object.path);
        print('file = $file');
      });
    } catch (e) {
      print('error kaaaa peeeee saoooooooo');
    }
  }

  Widget GalleryBtn() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 36.0,
        color: Colors.orange.shade900,
      ),
      onPressed: () {
        chooseImage(ImageSource.gallery);
      },
    );
  }

  Widget showBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [CameraBtn(), GalleryBtn()],
    );
  }

  Widget showImage() {
    return Container(
      padding: EdgeInsets.all(30.0),
      //color: Colors.grey, //ด฿ขอบเขตเฉยๆ
      width: MediaQuery.of(this.context).size.width,
      height: MediaQuery.of(this.context).size.height * 0.33,
      // ignore: unnecessary_null_comparison
      child: file == null ? Image.asset('images/image.png') : Image.file(file),
      //child: Image.asset('images/image.png'),
    );
  }

  Widget showContent() {
    return SingleChildScrollView(
      //คีย์บอร์ดล้น
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showImage(),
          showBtn(),
          NameForm(),
          DetailForm(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          showContent(),
          uploadBtn(),
        ],
      ),
    );
  }
}
