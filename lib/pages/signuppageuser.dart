import 'dart:io';

import 'package:eventnoti/main.dart';
import 'package:eventnoti/widgets/dropdownlist.dart';
import 'package:eventnoti/widgets/imagepicker.dart';
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
  dynamic val = [false, false, false];

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
              FormFieldCus(name: "Username"),
              SizedBox(
                height: 20,
              ),
              FormFieldCus(name: "password"),
              SizedBox(
                height: 20,
              ),
              FormFieldCus(name: "Name"),
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
                            title: Text("Meetup"),
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
              ElevatedButton(onPressed: (() {}), child: Text("Sign Up")),
            ],
          ),
        ),
      ),
    );
  }
}
