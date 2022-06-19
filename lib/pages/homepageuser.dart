import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({Key? key}) : super(key: key);

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  dynamic val = [false, false, false];
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
                    value: val[0],
                    onChanged: (value) {
                      setState(() {
                        val[0] = value;
                      });
                    }),
                CheckboxListTile(
                    title: Text("Arts"),
                    value: val[1],
                    onChanged: (value) {
                      setState(() {
                        val[1] = value;
                      });
                    }),
                CheckboxListTile(
                    title: Text("Sports"),
                    value: val[2],
                    onChanged: (value) {
                      setState(() {
                        val[2] = value;
                      });
                    }),
              ],
            ),
          ),
          body:
              TabBarView(children: [Text("1"), EventRe(), OrgRe(), Text("4")]),
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
