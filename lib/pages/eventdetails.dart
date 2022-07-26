import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Eventdet extends StatefulWidget {
  String name;
  Eventdet({Key? key, required this.name}) : super(key: key);

  @override
  State<Eventdet> createState() => _EventdetState();
}

class _EventdetState extends State<Eventdet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Event Details"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('events')
                .orderBy("score", descending: true)
                .snapshots(),
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

                    if ( //d1.compareTo(d2) > 0 &&
                        data!['name'] != widget.name) {
                      return Column(
                        children: [
                          Image.network(data['url']),
                          Row(
                            children: [Text("Name"), Text(data['name'])],
                          ),
                          Row(
                            children: [
                              Text("Conductucted by"),
                              Text(data['organizationname'])
                            ],
                          ),
                          Row(
                            children: [
                              Text("Start date"),
                              Text(data['startDate'])
                            ],
                          ),
                          Row(
                            children: [
                              Text("Starting time"),
                              Text(data['startTime'])
                            ],
                          ),
                          Row(
                            children: [
                              Text("Organization name"),
                              Text(data['organizationname'])
                            ],
                          ),
                          // Row(children: [Text(""),Text(data[''])],),
                        ],
                      );
                    }
                    return Card();
                  }).toList(),
                );
            },
          ),
        ));
  }
}
