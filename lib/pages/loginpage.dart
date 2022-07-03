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
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  //FirebaseFirestore ins = FirebaseFirestore.instance;
  late String _email = '', _password;
  double opacityLevel = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Color.fromARGB(255, 118, 114, 114),
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
                        backgroundColor: Colors.amber,
                      ),
                    ))),
                Expanded(
                  flex: 6,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          'Log In',
                          style: TextStyle(fontSize: 20),
                        ),
                        // width: MediaQuery.of(context).size.width - 75,
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Email ID',
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              // child: Padding(
                              //   // padding: EdgeInsets.symmetric(vertical: 13),
                              child: Container(
                                height: 30,
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
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      height: 30,
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
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(10.0),
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 10),
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
                    color: Color(0xFFD5D5D5),
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
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 30,
                      child: Center(
                          child: Text("Log in",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.black))),
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
                            style:
                                TextStyle(decoration: TextDecoration.underline))
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
      ),
      // ),
      //   ),
      //   //     ],
      //   //   ),
      //   // ),
      // ),
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
        Text(
          'Event Notifier',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: size * 0.7,
            color: con ? Colors.black : Colors.white,
          ),
        ),
        Text(
          'Never miss a oppurtunity',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: size * 0.3,
            color: con ? Colors.black : Colors.white,
          ),
        ),
      ],
    );
  }
}
