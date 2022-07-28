// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventnoti/pages/createevent.dart';
import 'package:eventnoti/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomePageOrg extends StatefulWidget {
  const HomePageOrg({Key? key}) : super(key: key);

  @override
  State<HomePageOrg> createState() => _HomePageOrgState();
}

class _HomePageOrgState extends State<HomePageOrg>
    with SingleTickerProviderStateMixin {
  //dynamic val = [false, false, false];
  late TabController _tabController;
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              GestureDetector(
                child: Icon(Icons.logout),
                onTap: () {
                  Get.to(Login());
                },
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
          floatingActionButton: _tabController.index == 1
              ? FloatingActionButton(
                  shape: StadiumBorder(),
                  onPressed: () {
                    Get.to(CreateEvent());
                  },
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.add,
                    size: 20.0,
                  ))
              : null,
          body: TabBarView(
              controller: _tabController,
              children: [dashboard(), EventRe(), OrgRe()]),
          bottomNavigationBar: BottomAppBar(
            elevation: 100,
            child: Container(
                color: Colors.black,
                height: 60,
                child: TabBar(controller: _tabController, tabs: [
                  Row(
                    children: [
                      Icon(Icons.home),
                      SizedBox(width: 10),
                      Text("Home"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 10),
                      Text("Events"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Text("Requests"),
                    ],
                  ),
                ])),
          ),
        ));
  }
}

String a = "";

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  Future<int> st() async {
    return 1;
  }

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: db.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else
            // ignore: curly_braces_in_flow_control_structures
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: snapshot.data!.docs.map((doc) {
                  Map<String, dynamic>? data =
                      doc.data() as Map<String, dynamic>?;
                  DateTime d1 = DateTime.parse(data!['endDate']);
                  DateTime now = new DateTime.now();
                  DateTime d2 = new DateTime(now.year, now.month, now.day);
                  final User? user = FirebaseAuth.instance.currentUser;
                  print(user!.email);
                  if (data['username'] == user.email) {
                    a = data['organizationname'];
                    return GestureDetector(
                      onPanUpdate: (details) async {
                        // Swiping in right direction.
                        if (details.delta.dx > 0) {}

                        // Swiping in left direction.
                        if (details.delta.dx < 0) {
                          final _db = FirebaseFirestore.instance;

                          await _db
                              .collection("events")
                              .doc(data['name'])
                              .delete();
                        }
                      },
                      child: Card(
                        child: ListTile(
                          // trailing: Expanded(
                          //   child: Row(
                          //     children: [
                          //       Text(data['endDate'].toString()),
                          //       Text(data['startDate'].toString()),
                          //     ],
                          //   ),
                          // ),
                          title: Row(
                            children: [
                              Text(data['name'].toString()),
                              Expanded(child: SizedBox()),
                              Text("Start: ${data['startDate'].toString()}"),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(data['description'].toString()),
                              Expanded(child: SizedBox()),
                              Text("End: ${data['endDate'].toString()}"),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Card();
                }).toList(),
              ),
            );
        },
      ),
    );
  }
}

class EventRe extends StatefulWidget {
  const EventRe({Key? key}) : super(key: key);

  @override
  State<EventRe> createState() => _EventReState();
}

class _EventReState extends State<EventRe> {
  List<String> events = [
    "Coding Competition",
    "Hackathon",
    "Speech",
    "Debate ",
    "Quiz Competition",
    "Special Day Events",
    "Writing Competition",
    "Drawing Competition"
  ];
  List<String> eventss = [
    "Coding Competition",
    "Hackathon",
    "Speech",
    "Debate ",
    "Quiz Competition",
    "Special Day Events",
    "Writing Competition",
    "Drawing Competition"
  ];
  void searchevent(String value) {
    final sugg = events.where((element) {
      return element.toLowerCase().contains(value.toLowerCase());
    }).toList();
    setState(() {
      eventss = sugg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              onChanged: searchevent,
              decoration: InputDecoration(
                  hintText: 'Event name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.white))),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: eventss.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        eventss[index],
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    );
                  })),
        ],
      ),
    );
  }
}

class A {
  late String username;
  late String id;

  A(this.username, this.id);
}

class OrgRe extends StatefulWidget {
  const OrgRe({Key? key}) : super(key: key);

  @override
  State<OrgRe> createState() => _OrgReState();
}

class _OrgReState extends State<OrgRe> {
  /*List<String> events = [
    "MACE",
    "IEEE",
    "CODECHEF MACE CHAPTER",
    "NSS",
    "DEBATE CLUB",
    "TEDX",
  ];
  List<String> eventss = [
    "MACE",
    "IEEE",
    "CODECHEF MACE CHAPTER",
    "NSS",
    "DEBATE CLUB",
    "TEDX",
  ];
  void searchevent(String value) {
    final sugg = events.where((element) {
      return element.toLowerCase().contains(value.toLowerCase());
    }).toList();
    setState(() {
      eventss = sugg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: TextField(
            onChanged: searchevent,
            decoration: InputDecoration(
                hintText: 'Organization name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black))),
          ),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: eventss.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(eventss[index]),
                    trailing: Icon(Icons.arrow_forward_ios),
                  );
                })),
      ],
    );
  }*/
  final db = FirebaseFirestore.instance;
  List po = <Map>[];
  @override
  Future<int> stt() async {
    User? user1 = FirebaseAuth.instance.currentUser;
    var collection = FirebaseFirestore.instance.collection("organization");
    var querySnapshot = await collection.get();

    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      print(user1!.email! + " " + data['username']);
      if (data['username'] == user1!.email) {
        a = data['name'];
        print(a);
      }
    }

    return 1;
  }

  Future<int> st() async {
    User? user1 = FirebaseAuth.instance.currentUser;

    await stt();
    //pendingmembers
    print("sda " + a);
    dynamic aaa = await FirebaseFirestore.instance
        .collection("organization")
        .doc(a)
        .get();
    po = [];

    for (var query in aaa.data()['pendingmembers']) {
      print(query);
      //A a = A(query['username'], query['id']);
      po.add({"username": query['username'], 'id': query['id']});
    }
    print(po.length);
    return 1;
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: FutureBuilder(
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/bg.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView.builder(
                    itemCount: po.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                        title: Row(
                          children: [
                            Text(po[index]["username"]),
                            //
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    print(po);
                                  });

                                  FirebaseFirestore.instance
                                      .collection("organization")
                                      .doc(a)
                                      .update({
                                    "approvedmembers": FieldValue.arrayUnion([
                                      {
                                        "username": po[index]["username"],
                                        "id": po[index]["id"]
                                      }
                                    ])
                                  });
                                  FirebaseFirestore.instance
                                      .collection("user")
                                      .doc(po[index]["username"])
                                      .update({
                                    "organizations": FieldValue.arrayUnion([a])
                                  });
                                  // FirebaseFirestore.instance
                                  //     .collection("organization")
                                  //     .doc(a)
                                  //     .update({
                                  // "pendingmembers": FieldValue.arrayRemove([
                                  //   {"username": po[index]["username"],
                                  //       "id": po[index]["id"]}
                                  // ])
                                  // });
                                  FirebaseFirestore.instance
                                      .collection("organization")
                                      .doc(a)
                                      .update({
                                    "pendingmembers": FieldValue.arrayRemove([
                                      {
                                        "username": po[index]["username"],
                                        "id": po[index]["id"]
                                      }
                                    ])
                                  });
                                },
                                icon: Icon(Icons.check)),
                            IconButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("organization")
                                      .doc(a)
                                      .update({
                                    "pendingmembers":
                                        FieldValue.arrayRemove(po[index])
                                  });
                                  FirebaseFirestore.instance
                                      .collection("organization")
                                      .doc(a)
                                      .update({
                                    "deniedmembers":
                                        FieldValue.arrayUnion(po[index])
                                  });
                                },
                                icon: Icon(Icons.flag)),
                            IconButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("organization")
                                      .doc(a)
                                      .update({
                                    "pendingmembers":
                                        FieldValue.arrayRemove(po[index])
                                  });
                                },
                                icon: Icon(Icons.close)),
                          ],
                        ),
                        subtitle: Text(po[index]["id"]),
                        // trailing: Row(
                        //   children: [
                        //
                        //   ],

                        // )
                      ));
                    }),
              );
            }
          }),
          future: st()),
    );
  }
}
