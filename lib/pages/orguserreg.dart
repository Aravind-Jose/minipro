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
  var lis1 = [];
  final User? user = FirebaseAuth.instance.currentUser;
  String buttonText = "Register";
  Future<int> st() async {
    collection = FirebaseFirestore.instance.collection("organization");
    querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data1 = queryDocumentSnapshot.data();

      if (data1['name'] == widget.name) {
        if (data1['approvedmembers'] != null &&
            data1['approvedmembers'].contains(user!.email)) {
          buttonText = 'approved';
        } else if (data1['pendingmembers'] != null &&
            data1['pendingmembers'].contains(user!.email)) {
          buttonText = 'pending';
        } else {
          buttonText = 'Register';
          if (data1['pendingmembers'] == null ||
              data1['pendingmembersid'] == null) {
            lis = [];
            lis1 = [];
          } else {
            lis = data1['pendingmembers'];
            lis1 = data1['pendingmembersid'];
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
            bottomNavigationBar: ElevatedButton(
                onPressed: buttonText == "Register"
                    ? () {
                        lis.add(user!.email);
                        lis1.add(regno.text);

                        /// want to correct the details needed to be added to the database want to add email and registration number
                        CollectionReference users1 = FirebaseFirestore.instance
                            .collection('organization');
                        print(lis);
                        users1.doc(widget.name).update({
                          'pendingmembers': lis,
                          'pendingmembersid': lis1,
                        });
                        Get.back();
                      }
                    : null,
                child: Text(buttonText)),
            body: Column(
              children: [
                Text(
                  widget.name,
                ),
                Text(widget.desc),
                TextField(
                  controller: regno,
                ),
              ],
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
