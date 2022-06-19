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

class SignuppageOrg extends StatefulWidget {
  const SignuppageOrg({Key? key}) : super(key: key);

  @override
  State<SignuppageOrg> createState() => _SignuppageOrgState();
}

class _SignuppageOrgState extends State<SignuppageOrg> {
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
              FormFieldCus(name: "Description"),
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
              ElevatedButton(onPressed: (() {}), child: Text("Sign Up")),
            ],
          ),
        ),
      ),
    );
  }
}
