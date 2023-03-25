import 'dart:convert';

import '../screens/addTreatment.dart';
import '../screens/hairStyleList.dart';
import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/treatmentList.dart';
import '../screens/viewEmpLeaves.dart';
import '../screens/viewProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/newAppointment.dart';
import '../screens/viewAppointments.dart';
import '../screens/newEmpLeave.dart';
import '../model/user.dart';
import 'package:avatar_view/avatar_view.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  final storage = const FlutterSecureStorage();
  bool changeLogin = false;
  String username = "Guest";
  String avatarImg = "avtGuest.png";
  String email = "";
  bool isAdmin = false;
  bool isEmployee = false;
  bool isCustomer = false;
  late User sendUser;

  @override
  void initState() {
    super.initState();
    _check();
  }

  _check() async {
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
      setState(() {
        sendUser = userBody;
        changeLogin = true;
        username = userBody.name!;
        email = userBody.email!;
        if (userBody.role == "0") {
          avatarImg = "avt2.jpg";
          isAdmin = true;
        } else if (userBody.role == "1") {
          avatarImg = "avt3.jpg";
          isEmployee = true;
        } else if (userBody.role == "2") {
          avatarImg = "avt1.jpg";
          isCustomer = true;
        }
      });
    } else {
      setState(() {
        username = "Guest";
        email = "";
        changeLogin = false;
      });
    }
  }

  _logOut() async {
    await storage.delete(key: "token");
    Navigator.pushNamed(context, '/home');
    setState(() {
      _check();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color.fromARGB(255, 16, 16, 16),
      ),
      child: SizedBox(
        width: 250,
        child: Drawer(
          elevation: 5,
          child: Container(
            decoration: const BoxDecoration(),
            child: ListView(
              children: [
                SizedBox(
                  height: 130.0,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(0, 255, 255, 255),
                        Color.fromARGB(0, 22, 22, 22),
                      ],
                    )),
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewProfile(
                                        user: sendUser,propic: avatarImg,
                                      ),
                                    ))
                              },
                              child: CircleAvatar(
                                radius: 35.0,
                                backgroundColor: Color(0xFF778899),
                                backgroundImage:
                                    AssetImage('../assets/images/${avatarImg}'),
                              ),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    username,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    email,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 161, 161, 161),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text(
                    "Home",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  leading: Ink(
                    decoration: const ShapeDecoration(
                      color: Color.fromARGB(255, 33, 33, 33),
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.house),
                      color: const Color.fromARGB(255, 233, 232, 232),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const Home()));
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Divider(
                    color: Color.fromARGB(255, 67, 67, 67),
                  ),
                ),
                isAdmin || isCustomer
                    ? ListTile(
                        title: const Text(
                          "Appointments",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        leading: Ink(
                          decoration: const ShapeDecoration(
                            color: Color.fromARGB(255, 33, 33, 33),
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const FaIcon(FontAwesomeIcons.calendarCheck),
                            color: Color.fromARGB(255, 233, 232, 232),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const ViewAppointments()));
                        },
                      )
                    : const Padding(padding: EdgeInsets.all(0.0)),
                isAdmin || isCustomer
                    ? const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Divider(
                          color: Color.fromARGB(255, 67, 67, 67),
                        ),
                      )
                    : const Padding(padding: EdgeInsets.all(0.0)),
                isAdmin
                    ? ListTile(
                        title: const Text(
                          "Hair Styles",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        leading: Ink(
                          decoration: const ShapeDecoration(
                            color: Color.fromARGB(255, 33, 33, 33),
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const FaIcon(FontAwesomeIcons.cut),
                            color: Color.fromARGB(255, 233, 232, 232),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  HairStyleList()));
                        },
                      )
                    : const Padding(padding: EdgeInsets.all(0.0)),
                isAdmin
                    ? const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Divider(
                          color: Color.fromARGB(255, 67, 67, 67),
                        ),
                      )
                    : const Padding(padding: EdgeInsets.all(0.0)),
                isAdmin
                    ? ListTile(
                        title: const Text(
                          "Treatments",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        leading: Ink(
                          decoration: const ShapeDecoration(
                            color: Color.fromARGB(255, 33, 33, 33),
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon:
                                const FaIcon(FontAwesomeIcons.suitcaseMedical),
                            color: Color.fromARGB(255, 233, 232, 232),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TreatmentList()));
                        },
                      )
                    : const Padding(padding: EdgeInsets.all(0.0)),
                isAdmin
                    ? const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Divider(
                          color: Color.fromARGB(255, 67, 67, 67),
                        ),
                      )
                    : const Padding(padding: EdgeInsets.all(0.0)),
                isAdmin || isEmployee
                    ? ListTile(
                        title: const Text(
                          "Employee Leave",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        leading: Ink(
                          decoration: const ShapeDecoration(
                            color: Color.fromARGB(255, 33, 33, 33),
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const FaIcon(FontAwesomeIcons.addressBook),
                            color: Color.fromARGB(255, 233, 232, 232),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const ViewEmpLeaves()));
                        },
                      )
                    : const Padding(padding: EdgeInsets.all(0.0)),
                isAdmin || isEmployee
                    ? const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Divider(
                          color: Color.fromARGB(255, 67, 67, 67),
                        ),
                      )
                    : const Padding(padding: EdgeInsets.all(0.0)),
                         ListTile(
                  title: const Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  leading: Ink(
                    decoration: const ShapeDecoration(
                      color: Color.fromARGB(255, 33, 33, 33),
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.cog),
                      color: const Color.fromARGB(255, 233, 232, 232),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Divider(
                          color: Color.fromARGB(255, 67, 67, 67),
                        ),
                      ),
                     ListTile(
                  title: const Text(
                    "About",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  leading: Ink(
                    decoration: const ShapeDecoration(
                      color: Color.fromARGB(255, 33, 33, 33),
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.info),
                      color: const Color.fromARGB(255, 233, 232, 232),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Divider(
                          color: Color.fromARGB(255, 67, 67, 67),
                        ),
                      ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    !changeLogin
                        ? ListTile(
                            title: const Text(
                              "Log In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                            leading: Ink(
                              decoration: const ShapeDecoration(
                                color: Color.fromARGB(255, 33, 33, 33),
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: FaIcon(
                                    FontAwesomeIcons.arrowRightToBracket),
                                color: Color.fromARGB(255, 233, 232, 232),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => Login()));
                            },
                          )
                        : ListTile(
                            title: const Text(
                              "Log Out",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                            leading: Ink(
                              decoration: const ShapeDecoration(
                                color: Color.fromARGB(255, 33, 33, 33),
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: FaIcon(
                                    FontAwesomeIcons.arrowRightToBracket),
                                color: Color.fromARGB(255, 233, 232, 232),
                                onPressed: () {
                                  _logOut();
                                },
                              ),
                            ),
                            onTap: () {
                              _logOut();
                            },
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
