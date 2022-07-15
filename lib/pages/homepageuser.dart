import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventnoti/pages/orguserreg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomePageUser extends StatefulWidget {
  static dynamic val = [
    true,
    true,
    true,
  ];
  const HomePageUser({Key? key}) : super(key: key);

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  //final db = FirebaseFirestore.instance;
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Homepage"),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    'Interests',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  decoration: BoxDecoration(color: Colors.black),
                ),
                CheckboxListTile(
                    title: Text("Coding"),
                    value: HomePageUser.val[0],
                    onChanged: (value) {
                      setState(() {
                        HomePageUser.val[0] = value;
                      });
                    }),
                CheckboxListTile(
                    title: Text("Arts"),
                    value: HomePageUser.val[1],
                    onChanged: (value) {
                      setState(() {
                        HomePageUser.val[1] = value;
                      });
                    }),
                CheckboxListTile(
                    title: Text("Sports"),
                    value: HomePageUser.val[2],
                    onChanged: (value) {
                      setState(() {
                        HomePageUser.val[2] = value;
                      });
                    }),
              ],
            ),
          ),
          body: TabBarView(children: [
            Dashboarduser(
              db: db,
            ),
            EventRe(),
            OrgRe(),
            fav(),
          ]),
          bottomNavigationBar: BottomAppBar(
            elevation: 100,
            child: Container(
                color: Colors.black,
                height: 60,
                child: TabBar(tabs: [
                  Text("List"),
                  Text("Recommendation"),
                  Text("Oranganization"),
                  Text("Favorites"),
                ])),
          ),
        ));
  }
}

class fav extends StatefulWidget {
  fav({Key? key}) : super(key: key);

  @override
  State<fav> createState() => _favState();
}

class _favState extends State<fav> {
  var querySnapshot;
  var collection;
  var lis = [];
  Future<int> st() async {
    final User? user = FirebaseAuth.instance.currentUser;

    collection = FirebaseFirestore.instance.collection("user");
    querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data1 = queryDocumentSnapshot.data();

      if (data1['username'] == user!.email) {
        data1['favorites'] == null
            ? lis = []
            : lis = List.from(data1['favorites']);
        print(lis);
        break;
      }
    }
    return 1;
  }

  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 150,
              child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection('events')
                    .orderBy("startDate", descending: true)
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
                        DateTime d1 = DateTime.parse(data!['endDate']);
                        DateTime now = new DateTime.now();
                        DateTime d2 =
                            new DateTime(now.year, now.month, now.day);

                        print("sasd : " + data['name']);
                        print("lis :" + lis.toString());
                        print("co :" + lis.contains(data['name']).toString());
                        if (d1.compareTo(d2) > 0 &&
                            lis.contains(data['name'])) {
                          return Card(
                            child: ListTile(
                              title: Row(
                                children: [
                                  Text(data['name'].toString()),
                                  Expanded(child: SizedBox()),
                                  Text(
                                      "Start: ${data['startDate'].toString()}"),
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
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
        future: st());
  }
}

class Dashboarduser extends StatefulWidget {
  FirebaseFirestore db;
  Dashboarduser({Key? key, required this.db}) : super(key: key);

  @override
  State<Dashboarduser> createState() => _DashboarduserState();
}

class _DashboarduserState extends State<Dashboarduser> {
  var lis = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomePageUser.val[0] == true
            ? Row(
                children: [
                  Text(
                    "Coding",
                    textAlign: TextAlign.left,
                  ),
                ],
              )
            : SizedBox(),
        HomePageUser.val[0] == true
            ? Listview(
                db: widget.db,
                cate: "Coding",
                lis: lis,
              )
            : SizedBox(),
        HomePageUser.val[1] == true
            ? Row(
                children: [
                  Text(
                    "Arts",
                    textAlign: TextAlign.left,
                  ),
                ],
              )
            : SizedBox(),
        HomePageUser.val[1] == true
            ? Listview(
                db: widget.db,
                cate: "Arts",
                lis: lis,
              )
            : SizedBox(),
        HomePageUser.val[2] == true
            ? Row(
                children: [
                  Text(
                    "Sports",
                    textAlign: TextAlign.left,
                  ),
                ],
              )
            : SizedBox(),
        HomePageUser.val[2] == true
            ? Listview(
                db: widget.db,
                cate: "Sports",
                lis: lis,
              )
            : SizedBox(),
      ],
    );
  }
}

class EventRe extends StatefulWidget {
  const EventRe({Key? key}) : super(key: key);

  @override
  State<EventRe> createState() => _EventReState();
}

class Listview extends StatefulWidget {
  FirebaseFirestore db;
  String cate;
  var lis;
  var regeve;
  Listview({Key? key, required this.db, required this.cate, this.lis})
      : super(key: key);

  @override
  State<Listview> createState() => _ListviewState();
}

class _ListviewState extends State<Listview> {
  var details = new Map();
  var buttontxt = new Map();
  var liss = [];
  var liss1 = [];
  final User? user = FirebaseAuth.instance.currentUser;
  String buttext = "Register";
  Future<int> st() async {
    //final User? user = FirebaseAuth.instance.currentUser;
    var querySnapshot1;
    var collection1;

    collection1 = FirebaseFirestore.instance.collection("user");
    querySnapshot1 = await collection1.get();
    for (var queryDocumentSnapshot in querySnapshot1.docs) {
      Map<String, dynamic> data1 = queryDocumentSnapshot.data();

      if (data1['username'] == user!.email) {
        //print(data1['favorites'].length);
        if (data1['favorites'] == null) {
          widget.lis = [];
        } else {
          widget.lis = List.from(data1['favorites']);
        }
        if (data1['regEvents'] == null) {
          liss1 = [];
        } else {
          liss1 = List.from(data1['regEvents']);
        }
        // if (data1['participants'] == null) {
        //   widget.regeve = [];
        // } else {
        //   widget.regeve = List.from(data1['favorites']);
        // }
        //print(lis.isEmpty);
        break;
      }
    }
    var collection = FirebaseFirestore.instance.collection("events");
    var querySnapshot = await collection.get();

    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if (widget.lis.isEmpty == false) {
        print("sds f :" + widget.lis.toString());
        print(data['name']);
        if (widget.lis.contains(data['name'])) {
          details['${data['name']}'] = "red";
        } else {
          details['${data['name']}'] = "grey";
        }
      } else {
        details['${data['name']}'] = "grey";
      }
      if (data['participants'] == null) {
        liss = [];
      } else {
        print("Not null");
        liss = List.from(data['participants']);
      }
      if (liss.contains(user!.email)) {
        buttontxt['${data['name']}'] = "Registered";
      } else {
        buttontxt['${data['name']}'] = "Register";
      }
    }

    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 150,
              child: StreamBuilder<QuerySnapshot>(
                stream: widget.db
                    .collection('events')
                    .orderBy("startDate", descending: true)
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
                        DateTime d1 = DateTime.parse(data!['endDate']);
                        DateTime now = new DateTime.now();
                        DateTime d2 =
                            new DateTime(now.year, now.month, now.day);
                        if (d1.compareTo(d2) > 0 &&
                            data['category'] == widget.cate) {
                          return Card(
                            child: ListTile(
                              leading: ElevatedButton(
                                  onPressed: () {
                                    if (buttontxt['${data['name']}'] ==
                                        "Register") {
                                      setState(() {
                                        buttontxt['${data['name']}'] =
                                            "Registered";
                                        if (data['participants'] == null) {
                                          liss = [];
                                        } else {
                                          print("Not null");
                                          liss =
                                              List.from(data['participants']);
                                        }
                                        liss.add(user!.email);
                                        CollectionReference users =
                                            FirebaseFirestore.instance
                                                .collection('events');
                                        users.doc('${data['name']}').update({
                                          'participants': liss,
                                        });
                                        liss1.add(data['name']);
                                        CollectionReference users2 =
                                            FirebaseFirestore.instance
                                                .collection('user');
                                        users2.doc('${user!.uid}').update({
                                          'regEvents': liss1,
                                        });
                                      });
                                    }
                                  },
                                  child: Text(buttontxt['${data['name']}'])),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: details['${data['name']}'] == "red"
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    details['${data['name']}'] =
                                        details['${data['name']}'] == "red"
                                            ? "grey"
                                            : "red";
                                    final User? user =
                                        FirebaseAuth.instance.currentUser;
                                    print(user!.uid);
                                    if (details['${data['name']}'] == "red") {
                                      widget.lis.add(data['name']);
                                      CollectionReference users =
                                          FirebaseFirestore.instance
                                              .collection('user');
                                      users.doc(user.uid).update({
                                        'favorites': widget.lis,
                                      });
                                    } else {
                                      widget.lis.remove(data['name']);
                                      CollectionReference users =
                                          FirebaseFirestore.instance
                                              .collection('user');
                                      users.doc(user.uid).update({
                                        'favorites': widget.lis,
                                      });
                                    }
                                  });
                                },
                              ),
                              title: Text(data['name'].toString()),
                              subtitle: Text(data['description'].toString()),
                            ),
                          );
                        }
                        return Card();
                      }).toList(),
                    );
                },
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
        future: st());
  }
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
  var querySnapshot1;
  var collection1;
  List<String> events = [];
  // "MACE",
  // "IEEE",
  // "CODECHEF MACE CHAPTER",
  // "NSS",
  // "DEBATE CLUB",
  // "TEDX",
  List<String> eventss = [];
  List<String> des = [];
  void searchevent(String value) {
    final sugg = events.where((element) {
      return element.toLowerCase().contains(value.toLowerCase());
    }).toList();
    setState(() {
      eventss = sugg;
    });
  }

  late FirebaseFirestore db;
  int co = 0;
  Future<int> st1() async {
    collection1 = FirebaseFirestore.instance.collection("organization");
    querySnapshot1 = await collection1.get();
    print("dssd");
    for (var queryDocumentSnapshot in querySnapshot1.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if (co == 0) {
        events.add(data['name']);
        des.add(data['description']);
      }
    }
    if (co == 0) {
      eventss = events;
    }
    co++;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
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
                          return GestureDetector(
                            onTap: (() {
                              Get.to(OrgUserReg(
                                name: eventss[index],
                                desc: des[index],
                              ));
                            }),
                            child: ListTile(
                              title: Text(eventss[index]),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          );
                        })),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
        future: st1());
  }
}
