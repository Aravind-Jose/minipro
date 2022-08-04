import 'dart:developer';
import 'dart:io';
import 'package:eventnoti/pages/aa.dart';
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
  TimeOfDay selectedTime = TimeOfDay(hour: 24, minute: 47);
  TextEditingController name = TextEditingController();
  TextEditingController des = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController ades = TextEditingController();
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

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.all(10),
            //color: Color.fromARGB(255, 187, 179, 179),
            child: Column(
              children: [
                Row(
                  children: [
                    Radio(
                        value: "online",
                        groupValue: type,
                        onChanged: (value) {
                          setState(() {
                            type = value.toString();
                          });
                        }),
                    Text(
                      "Online",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Radio(
                        //MaterialStateProperty.all<Color>(Colors.white)
                        //hoverColor: Colors.white,
                        value: "Offline",
                        groupValue: type,
                        onChanged: (value) {
                          setState(() {
                            type = value.toString();
                          });
                        }),
                    Text(
                      "Offline",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Start",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: SizedBox()),
                    IconButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        icon: Icon(Icons.edit_calendar_outlined)),
                    Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "End",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: SizedBox()),
                    IconButton(
                        onPressed: () {
                          _selectDate1(context);
                        },
                        icon: Icon(Icons.edit_calendar_outlined)),
                    Text(
                      "${selectedDate1.day}/${selectedDate1.month}/${selectedDate1.year}",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Commencement Time",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _selectTime(context);
                      },
                      child: Icon(
                        Icons.lock_clock_outlined,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${selectedTime.hour}:${selectedTime.minute}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
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
                FormFieldCus(con: ades, name: "Exclusive details of event"),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            "Region",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        )),
                    Expanded(
                      child: DropDownButtonCus(
                        type: "1",
                      ),
                      flex: 3,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            "Category",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        )),
                    Expanded(
                      child: DropDownButtonCus(
                        type: "2",
                      ),
                      flex: 3,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            "Image",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        )),
                    Expanded(
                      child: ImageUploads(cat: "events", name: name.text),
                      flex: 3,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ))),
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
                        Map<String, dynamic> data =
                            queryDocumentSnapshot.data();
                        name_us = data['name'];
                        us = data['username'];
                        print(us + " ss" + name_us);
                        if (us == user.email) {
                          break;
                        }
                      }
                      int scor = 0;
                      if ((DropDownButtonCus.selectedValue == "IIT" ||
                              DropDownButtonCus.selectedValue == "NIT") &&
                          type == "online") {
                        scor = 4;
                      } else if ((DropDownButtonCus.selectedValue == "IIT" ||
                              DropDownButtonCus.selectedValue == "NIT") &&
                          type == "offline") {
                        scor = 3;
                      } else if (type == "online") {
                        scor = 2;
                      } else if (type == "offline") {
                        scor = 1;
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
                        'endDate':
                            DateFormat('yyyy-MM-dd').format(selectedDate1),
                        'startTime': selectedTime.hour.toString() +
                            ":" +
                            selectedTime.minute.toString(),
                        'username': us,
                        'url': ImageUploads.url,
                        'type': type,
                        'ades': ades.text,
                        'score': scor,
                      };
                      orgdata.set(json);
                      Get.to(HomePageOrg());
                    }),
                    child: Text(
                      "Create Event",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
