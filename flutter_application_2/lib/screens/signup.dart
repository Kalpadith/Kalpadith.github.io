import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../screens/viewStyle.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../screens/login.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import 'home.dart';

class SignUp extends StatefulWidget {
  static const String routeName = '/signup';
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? fullName;
  String? email;
  String? mobile;
  String? password;
  String? role = "2";
  bool isLoading = false;

  createUser() async {
      setState(() {
      isLoading = true;
    });
    try {
      var response = await http.post(
          Uri.parse(
              'http://localhost:5000/user/create'),
          body: {
            "fullName": fullName,
            "email": email,
            "mobileNumber": mobile,
            "password": password,
            "role":role
          });
      print(response.body);
      Navigator.pushNamed(context, '/login');
      
    } catch (e) {
      print(e);
    }
        setState(() {
        isLoading = false;
      });
  }

  @override
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: <Widget>[
            Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                      image: AssetImage("../assets/images/back.png"),
                      fit: BoxFit.cover,
                      )),
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0, right: 20),
                child: Align(
                  alignment: const Alignment(-1, -1),
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                    color: Color.fromARGB(255, 8, 8, 8),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                          ));
                    },
                  ),
                ),
              ),
            ),
          ),
           !isLoading ? Padding(
              padding: const EdgeInsets.only(top: 160.0),
              child: ListView(children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: RichText(
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: GoogleFonts.dancingScript(
                                           fontSize: 45.0,
                                        ),
                      children: <TextSpan>[
                        new TextSpan(text: 'Sign'),
                        TextSpan(
                            text: 'Up',
                                style: GoogleFonts.dancingScript(
                                textStyle: const TextStyle(
                                color: Color.fromARGB(255, 255, 173, 167),
                                fontWeight: FontWeight.bold)
                           ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the name";
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() {
                        fullName = text;
                      });
                    },
                    controller: nameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the email";
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() {
                        email = text;
                      });
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the phone number";
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() {
                        mobile = text;
                      });
                    },
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the password";
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() {
                        password = text;
                      });
                    },
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    height: 50,
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                        child: const Text('Sign Up'),
                        style: ElevatedButton.styleFrom(
                            onPrimary: Colors.black,
                            primary: const Color.fromARGB(
                                          255, 211, 74, 74),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          createUser();
                        })),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment
                      .center, //Center Row contents vertically,
                  children: <Widget>[
                    const Text(
                      'Do you have an account?',
                      style: TextStyle(
                          color: Color.fromARGB(255, 136, 136, 136),
                          fontSize: 16),
                    ),
                    TextButton(
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 211, 74, 74),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(Login.routeName);
                      },
                    ),
                  ],
                ),
              ]
              )
              ):
                    Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(34, 33, 33, 0.856)),
                         child: const SpinKitFoldingCube(color: Color.fromARGB(255, 211, 74, 74),),
                        ),
        ]));
  }
}
