import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventnoti/main.dart';
import 'package:eventnoti/pages/homepageorg.dart';
import 'package:eventnoti/widgets/dropdownlist.dart';
import 'package:eventnoti/widgets/imagepicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/formfield.dart';

File? imageFile;

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  TextEditingController name = TextEditingController();
  TextEditingController des = TextEditingController();
  String? type;
  String date = "";
  DateTime selectedDate = DateTime.now();
  String date1 = "";
  DateTime selectedDate1 = DateTime.now();
  var name_us;
  var us;
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

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  _selectDate1(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate:
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate1 = selected;
      });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: Color.fromARGB(255, 187, 179, 179),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Online"),
                  Radio(
                      value: "online",
                      groupValue: type,
                      onChanged: (value) {
                        setState(() {
                          type = value.toString();
                        });
                      }),
                  Text("Offline"),
                  Radio(
                      value: "Offline",
                      groupValue: type,
                      onChanged: (value) {
                        setState(() {
                          type = value.toString();
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  Text("Start Date"),
                  IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: Icon(Icons.edit_calendar_outlined)),
                  Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                  SizedBox(
                    width: 20,
                  ),
                  Text("End Date"),
                  IconButton(
                      onPressed: () {
                        _selectDate1(context);
                      },
                      icon: Icon(Icons.edit_calendar_outlined)),
                  Text(
                      "${selectedDate1.day}/${selectedDate1.month}/${selectedDate1.year}")
                ],
              ),
              FormFieldCus(
                name: "Event Name",
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
                    child: DropDownButtonCus(
                      type: "1",
                    ),
                    flex: 3,
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Text("Category"),
                      )),
                  Expanded(
                    child: DropDownButtonCus(
                      type: "2",
                    ),
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
                    final orgdata = FirebaseFirestore.instance
                        .collection("events")
                        .doc(name.text);
                    final User? user = FirebaseAuth.instance.currentUser;
                    print(user!.email);
                    var collection =
                        FirebaseFirestore.instance.collection("organization");
                    var querySnapshot = await collection.get();
                    for (var queryDocumentSnapshot in querySnapshot.docs) {
                      Map<String, dynamic> data = queryDocumentSnapshot.data();
                      name_us = data['name'];
                      us = data['username'];
                      print(us + " ss" + name_us);
                      if (us == user.email) {
                        break;
                      }
                    }
                    final json = {
                      //'id': orgdata.id,
                      'name': name.text,
                      'organizationname': name_us,
                      'description': des.text,
                      'region': DropDownButtonCus.selectedValue,
                      'category': DropDownButtonCus.selectedValue2,
                      'startDate':
                          DateFormat('yyyy-MM-dd').format(selectedDate),
                      'endDate': DateFormat('yyyy-MM-dd').format(selectedDate1),
                      'username': us,
                    };
                    orgdata.set(json);
                    Get.to(HomePageOrg());
                  }),
                  child: Text("Create Event")),
            ],
          ),
        ),
      ),
    );
  }
}
