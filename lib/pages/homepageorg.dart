// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventnoti/pages/createevent.dart';
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
                  Text("Home"),
                  Text("Events"),
                  Text("Oranganization"),
                ])),
          ),
        ));
  }
}

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
                DateTime d1 = DateTime.parse(data!['endDate']);
                DateTime now = new DateTime.now();
                DateTime d2 = new DateTime(now.year, now.month, now.day);
                final User? user = FirebaseAuth.instance.currentUser;
                print(user!.email);
                if (data['username'] == user.email) {
                  return Card(
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
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: TextField(
            onChanged: searchevent,
            decoration: InputDecoration(
                hintText: 'Event name',
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
  }
}

class OrgRe extends StatefulWidget {
  const OrgRe({Key? key}) : super(key: key);

  @override
  State<OrgRe> createState() => _OrgReState();
}

class _OrgReState extends State<OrgRe> {
  List<String> events = [
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
  }
}
