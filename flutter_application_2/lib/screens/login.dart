import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/signup.dart';
import '../screens/viewStyle.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../screens/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../components/NavDrawer.dart';
import '../model/user.dart';
import 'home.dart';

class Login extends StatefulWidget {
  static const String routeName = '/login';
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();
  late final User user;
  String? email;
  String? password;
  bool isLoading = false;

  void showToast(msg) => Fluttertoast.showToast(
      msg: msg,
      fontSize: 18,
      backgroundColor: Color.fromARGB(255, 255, 17, 0),
      textColor: Color.fromARGB(255, 0, 0, 0));

  validateUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.post(
          Uri.parse('http://localhost:5000/user/validate'),
          body: {"email": email, "password": password});
      print(response.body);
      if (response.statusCode == 200) {
        await storage.write(key: "token", value: response.body);
        if (await storage.read(key: "token") != null) {
          var token = await storage.read(key: "token");
          var jsonUser = jsonDecode(token!);
          User userBody = User(
              jsonUser["_id"],
              jsonUser["fullName"],
              jsonUser["email"],
              jsonUser["mobileNumber"],
              jsonUser["password"],
              jsonUser["role"]);
          if (userBody.role == "0") {
            Navigator.pushNamed(context, '/addHairStyle');
          } else if (userBody.role == "1") {
            Navigator.pushNamed(context, '/home');
          } else if (userBody.role == "2") {
            Navigator.pushNamed(context, '/home');
          }
        }
      } else if (response.statusCode == 500) {
        print(response.body);
        showToast(response.body);
      } else {
        print(response.body);
        showToast("Error");
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
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
                    color: const Color.fromARGB(255, 8, 8, 8),
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
          !isLoading
              ? Container(
                  padding: const EdgeInsets.only(top: 160.0),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Form(
                          key: _formKey,
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
                                    new TextSpan(text: 'UpTown'),
                                    TextSpan(
                                        text: 'Salon',
                                        style: GoogleFonts.dancingScript(
                                            textStyle: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 173, 167),
                                          fontWeight: FontWeight.bold,
                                        ))),
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
                                    email = text;
                                  });
                                },
                                controller: emailController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2.0),
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
                                validator: (text) {
                                  print(text);
                                },
                                onChanged: (text) {
                                  setState(() {
                                    password = text;
                                  });
                                },
                                obscureText: true,
                                controller: passwordController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2.0),
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
                            TextButton(
                              style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.white,
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                  )),
                              onPressed: () {
                                //forgot password screen
                              },
                              child: const Text(
                                'Forgot Password',style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Container(
                                height: 50,
                                margin: const EdgeInsets.only(
                                    top: 30.0, bottom: 50.0),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.black,
                                      primary: const Color.fromARGB(
                                          255, 211, 74, 74),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  child: const Text('Login'),
                                  onPressed: () {
                                    validateUser();
                                  },
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Image.asset(
                                    '../assets/images/googleico.png',
                                    width: 100,
                                    height: 50,
                                  ),
                                ),
                                Expanded(
                                  child: Image.asset(
                                    '../assets/images/facebookico.png',
                                    width: 100,
                                    height: 50,
                                  ),
                                ),
                                Expanded(
                                  child: Image.asset(
                                    '../assets/images/appleico.png',
                                    width: 100,
                                    height: 50,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, //Center Row contents horizontally,
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, //Center Row contents vertically,
                              children: <Widget>[
                                const Text(
                                  'Does not have account?',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 136, 136, 136),
                                      fontSize: 16),
                                ),
                                TextButton(
                                  child: const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 211, 74, 74),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(SignUp.routeName);
                                  },
                                ),
                              ],
                            ),
                          ]))),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(34, 33, 33, 0.856)),
                  child: const SpinKitFoldingCube(
                    color: Color.fromARGB(255, 211, 74, 74),
                  ),
                ),
        ],
      ),
      drawer: NavDrawer(),
    );
  }
}
