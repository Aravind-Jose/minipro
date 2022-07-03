import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventnoti/main.dart';
import 'package:eventnoti/pages/loginpage.dart';
import 'package:eventnoti/widgets/dropdownlist.dart';
import 'package:eventnoti/widgets/imagepicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/formfield.dart';

File? imageFile;

class SignuppageOrg extends StatefulWidget {
  const SignuppageOrg({Key? key}) : super(key: key);

  @override
  State<SignuppageOrg> createState() => _SignuppageOrgState();
}

class _SignuppageOrgState extends State<SignuppageOrg> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController des = TextEditingController();
  @override
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: Color.fromARGB(255, 187, 179, 179),
          child: Column(
            children: [
              FormFieldCus(
                name: "Username",
                con: email,
              ),
              SizedBox(
                height: 20,
              ),
              FormFieldCus(
                name: "password",
                con: password,
              ),
              SizedBox(
                height: 20,
              ),
              FormFieldCus(
                name: "Name",
                con: name,
              ),
              SizedBox(
                height: 20,
              ),
              FormFieldCus(
                name: "Description",
                con: des,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Text("Region"),
                      )),
                  Expanded(
                    child: DropDownButtonCus(),
                    flex: 3,
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Text("Image"),
                      )),
                  Expanded(
                    child: Center(
                        child: imageFile == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton(
                                    color: Colors.greenAccent,
                                    onPressed: () {
                                      _getFromGallery();
                                      //Navigator.pop(context);
                                    },
                                    child: Text("PICK FROM GALLERY"),
                                  ),
                                  Container(
                                    height: 20.0,
                                  ),
                                  RaisedButton(
                                    color: Colors.lightGreenAccent,
                                    onPressed: () {
                                      _getFromCamera();
                                      //Navigator.pop(context);
                                    },
                                    child: Text("PICK FROM CAMERA"),
                                  )
                                ],
                              )
                            : Container(
                                height: 100,
                                width: 100,
                                child: Image.file(
                                  imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              )),
                    flex: 3,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: (() async {
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );
                      final orgdata = FirebaseFirestore.instance
                          .collection("organization")
                          .doc();
                      final json = {
                        //'id': orgdata.id,
                        'name': name.text,
                        'username': email.text,
                        'description': des.text,
                        'region': DropDownButtonCus.selectedValue,
                      };
                      orgdata.set(json);
                      Get.to(Login());
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  }),
                  child: Text("Sign Up")),
            ],
          ),
        ),
      ),
    );
  }
}
