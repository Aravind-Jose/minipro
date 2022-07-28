import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Books extends StatefulWidget {
  String name;
  Books({Key? key, required this.name}) : super(key: key);

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: db.collection('books').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            // ignore: curly_braces_in_flow_control_structures
            return ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: snapshot.data!.docs.map((doc) {
                Map<String, dynamic>? data =
                    doc.data() as Map<String, dynamic>?;
                print(data!['count']);
                if (data!['count'] >= 1) {
                  return Card(
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(data['name'].toString()),
                          Expanded(child: SizedBox()),
                          ElevatedButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection("books")
                                    .doc(data['id'].toString())
                                    .update({"count": data['count'] - 1});
                                CollectionReference users = FirebaseFirestore
                                    .instance
                                    .collection('user2');

                                users.doc(widget.name).update({
                                  'favourite':
                                      FieldValue.arrayUnion([data['name']]),
                                });
                              },
                              child: Text('Take')),
                        ],
                      ),
                    ),
                  );
                }
                return Card();
              }).toList(),
            );
        },
      ),
    );
  }
}
