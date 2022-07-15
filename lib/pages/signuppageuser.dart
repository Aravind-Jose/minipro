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

class SignuppageUser extends StatefulWidget {
  const SignuppageUser({Key? key}) : super(key: key);

  @override
  State<SignuppageUser> createState() => _SignuppageUserState();
}

class _SignuppageUserState extends State<SignuppageUser> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  dynamic val = [false, false, false];
  dynamic interests = ["Coding", "Arts", "Webinar"];

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
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Text("Interests"),
                      )),
                  Expanded(
                    child: Column(
                      children: [
                        CheckboxListTile(
                            title: Text("Coding"),
                            value: val[0],
                            onChanged: (value) {
                              setState(() {
                                val[0] = value;
                              });
                            }),
                        CheckboxListTile(
                            title: Text("Arts"),
                            value: val[1],
                            onChanged: (value) {
                              setState(() {
                                val[1] = value;
                              });
                            }),
                        CheckboxListTile(
                            title: Text("Webinar"),
                            value: val[2],
                            onChanged: (value) {
                              setState(() {
                                val[2] = value;
                              });
                            }),
                      ],
                    ),
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
                          .collection("user")
                          .doc(credential.user!.uid);
                      dynamic ins = [];
                      for (int i = 0; i < val.length; i++) {
                        if (val[i]) {
                          ins.add(interests[i]);
                        }
                      }
                      final json = {
                        //'id': orgdata.id,
                        'name': name.text,
                        'username': email.text,
                        'interests': ins,
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
