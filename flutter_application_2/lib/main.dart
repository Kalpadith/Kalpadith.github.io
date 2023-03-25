import '.../../screens/addHairStyle.dart';
import '.../../screens/login.dart';
import '.../../screens/signup.dart';
import '.../../screens/viewStyle.dart';
import '.../../screens/newAppointment.dart';
import '.../../screens/viewAppointments.dart';
import '.../../screens/hairStyleList.dart';

import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(const SalonApp());
}

class SalonApp extends StatelessWidget {
  const SalonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salon Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Home.routeName,
      routes: {
        Home.routeName: (context) => Home(),
        AddHairStyle.routeName: (context) => AddHairStyle(),
        // ViewHairStyle.routeName: (context) => ViewHairStyle(),
        Login.routeName: (context) => Login(),
        SignUp.routeName: (context) => SignUp(),
        NewAppointment.routeName: (context) => NewAppointment(),
        ViewAppointments.routeName: (context) => ViewAppointments(),
        HairStyleList.routeName: (context) => HairStyleList(),
      },

    );
  }
}
