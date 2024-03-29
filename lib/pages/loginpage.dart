import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventnoti/pages/homepageorg.dart';
import 'package:eventnoti/pages/homepageuser.dart';
import 'package:eventnoti/pages/selectionpage.dart';
import 'package:eventnoti/pages/selectionpageLogin.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

bool load = false;

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  //FirebaseFirestore ins = FirebaseFirestore.instance;
  late String _email = '', _password;
  double opacityLevel = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      key: _globalKey,
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          //color: Colors.white,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 2, child: TitleText(size: 40, con: false)),
              Expanded(
                  flex: 4,
                  child: Center(
                      child: Container(
                    width: 90,
                    height: 90,
                    child: CircleAvatar(
                      radius: 50,
                      child: Image.asset(
                        'images/msg.jpg',
                        fit: BoxFit.fill,
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                      ),
                    ),
                  ))),
              Text(
                'LogIn',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 80,
              ),
              Expanded(
                flex: 6,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // width: MediaQuery.of(context).size.width - 75,
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Username',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            // child: Padding(
                            //   // padding: EdgeInsets.symmetric(vertical: 13),
                            child: Container(
                              height: 40,
                              child: Center(
                                child: TextFormField(
                                  controller: email,
                                  // scrollPadding: EdgeInsets.all(0),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Enter Your Email Id";
                                    }
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  onSaved: (val) => _email = val!,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            //),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Password',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    child: TextFormField(
                                      controller: password,
                                      validator: (input) {
                                        if (input!.length < 6) {
                                          return 'Longer password please';
                                        }
                                      },
                                      obscureText: true,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                      onSaved: (val) => _password = val!,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(10.0),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      try {
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                                email: email.text);
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            content: const Text(
                                                "Password reset link has been sent to your email"),
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
                                      } catch (e) {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            content: const Text(
                                                "User does not exist"),
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
                                      }
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue,
                                          fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  color: Colors.white,
                  onPressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email.text, password: password.text);

                      QuerySnapshot<Map<String, dynamic>> doc =
                          await FirebaseFirestore.instance
                              .collection('user')
                              .where('username', isEqualTo: '${email.text}')
                              .get();
                      if (doc.docs.isNotEmpty) {
                        // todo
                        Get.to(HomePageUser());
                      } else {
                        // todo
                        Get.to(HomePageOrg());
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            content: const Text("No user found for that email"),
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
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            content: const Text(
                                "Wrong password provided for that user"),
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
                        print('Wrong password provided for that user.');
                      }
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 30,
                    child: Center(
                        child: Text("Login",
                            style:
                                TextStyle(fontSize: 17, color: Colors.black))),
                  ),
                ),
              ),
              Expanded(child: SizedBox(), flex: 1),
              Expanded(
                  child: InkWell(
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(text: 'Don\'t have an Account?'),
                      TextSpan(
                          text: ' Sign up',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue))
                    ])),
                    onTap: () {
                      Get.to(Selectionpage());
                    },
                  ),
                  flex: 1),
              Expanded(child: SizedBox(), flex: 2)
            ],
          ),
        ),
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  TitleText({required this.size, required this.con});
  final double size;
  final bool con;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Center(
          child: Text(
            'EVENT NOTIFIER',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: con ? Colors.black : Colors.white,
            ),
          ),
        ),
        Center(
          child: Text(
            'Never miss an oppurtunity',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 20,
              color: con ? Colors.black : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
