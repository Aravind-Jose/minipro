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
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
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
                name: "Password",
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
              Expanded(
                child: Column(
                  children: [
                    Text("Interests", style: TextStyle(fontSize: 20)),
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
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                width: 180,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ))),
                    onPressed: (() async {
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );
                        final orgdata = FirebaseFirestore.instance
                            .collection("user")
                            .doc(credential.user!.email);
                        dynamic ins = [];
                        for (int i = 0; i < val.length; i++) {
                          if (val[i]) {
                            ins.add(interests[i]);
                          }
                        }
                        List u = [];
                        final json = {
                          //'id': orgdata.id,
                          'name': name.text,
                          'username': email.text,
                          'interests': ins,
                          'favourite': [],
                          'regEvents': [],
                          'organizations': u,
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
                    child: Text(
                      "SignUp",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
