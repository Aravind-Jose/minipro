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
          padding: EdgeInsets.all(10),
          height: double.infinity,
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
                        data!['name'] == widget.name) {
                      return Column(
                        children: [
                          Container(
                            height: 400,
                            width: 400,
                            child: Image.network(
                              data['url'],
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //Image.network(data['url']),
                          Row(
                            children: [
                              Text(
                                "Name",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE0FBFC)),
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: 20,
                                ),
                              ),
                              Text(
                                data['name'],
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE0FBFC)),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Organization",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE0FBFC)),
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: 20,
                                ),
                              ),
                              Text(
                                data['organizationname'],
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE0FBFC)),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Start date",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE0FBFC)),
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: 20,
                                ),
                              ),
                              Text(
                                data['startDate'],
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE0FBFC)),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Starting time",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE0FBFC)),
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: 20,
                                ),
                              ),
                              Text(
                                data['startTime'],
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE0FBFC)),
                              )
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
