import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrgUserReg extends StatefulWidget {
  late String name;
  late String desc;
  OrgUserReg({
    Key? key,
    required this.name,
    required this.desc,
  }) : super(key: key);

  @override
  State<OrgUserReg> createState() => _OrgUserRegState();
}

class _OrgUserRegState extends State<OrgUserReg> {
  TextEditingController regno = TextEditingController();
  var querySnapshot;
  var collection;
  var lis = [];
  //var lis1 = [];
  final User? user = FirebaseAuth.instance.currentUser;
  String buttonText = "Register";
  String res = "pending";
  int flag = 1;
  var dem = [];
  Future<int> st() async {
    collection = FirebaseFirestore.instance.collection("organization");
    querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data1 = queryDocumentSnapshot.data();
      flag = 1;
      if (data1['name'] == widget.name) {
        if (data1['approvedmembers'] != []) {
          dem = data1['approvedmembers'];

          for (int i = 0; i < dem.length; i++) {
            if (dem[i]["username"] == user!.email) {
              flag = 0;
              res = "Approved";
              buttonText = "Check";
              return 1;
            }
          }
        }
        if (data1['pendingmembers'] != []) {
          dem = data1['pendingmembers'];

          for (int i = 0; i < dem.length; i++) {
            if (dem[i]["username"] == user!.email) {
              flag = 0;
              res = "Pending";
              buttonText = "Check";
              return 1;
            }
          }
        }
        if (flag == 1) {
          buttonText = 'Register';
          if (data1['pendingmembers'] != []) {
            print("fdsf");
            lis = [];
          } else {
            lis = data1['pendingmembers'];
            print(lis);
          }
        }
        break;
      }
    }
    return 1;
  }

  //TextEditingController des = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Material(
                elevation: 20,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 200,
                  width: 200,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.name,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(widget.desc),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 150,
                        child: TextField(
                          decoration: InputDecoration(
                            //fillColor: Colors.orange, filled: true
                            hintText: "Enter your regno",
                          ),
                          controller: regno,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: buttonText == "Register"
                              ? () {
                                  lis.add({
                                    "username": user!.email,
                                    "id": regno.text
                                  });

                                  /// want to correct the details needed to be added to the database want to add email and registration number
                                  CollectionReference users1 = FirebaseFirestore
                                      .instance
                                      .collection('organization');
                                  print(lis);

                                  users1.doc(widget.name).update({
                                    'pendingmembers': lis,
                                  });
                                  Get.back();
                                }
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      content: Text(res),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: const Text("Okay"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                          child: Text(buttonText))
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
      future: st(),
    );
  }
}
