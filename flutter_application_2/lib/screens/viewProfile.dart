import 'dart:convert';
import '../model//hairStyle.dart';
import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home.dart';

import '../service/agify.dart';

class ViewProfile extends StatefulWidget {
  static const String routeName = '/viewProfile';
  final String propic;
  final User? user;
  const ViewProfile({Key? key, required this.user,required this.propic}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 19, 19),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Color.fromARGB(255, 208, 208, 208),
              fontSize: 22,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 85.0,
                backgroundColor: Color(0xFF778899),
                backgroundImage: AssetImage('../assets/images/${widget.propic}'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 22.0),
                child: Text(
                  '${widget.user?.name}',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 25,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "@"+'${widget.user?.email}',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 240, 240, 240),
                      fontSize: 15,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                ),
              ),
                Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Padding(
               padding: const EdgeInsets.only(top:20.0,left: 12,right: 12),
                    child:Row(
                      mainAxisSize: MainAxisSize.min,
                      children:   [
                        FaIcon(FontAwesomeIcons.at,color: Color.fromARGB(255, 190, 192, 43), size: 19.0,),
                        Text("     "+'${widget.user?.email}',
                          style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 17,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400),
                          ),
                      ],
                    ),
              ),
                    Padding(
               padding: const EdgeInsets.only(top:20.0,left: 12,right: 12),
                    child:Row(
                      mainAxisSize: MainAxisSize.min,
                      children:  const [
                        FaIcon(FontAwesomeIcons.mapLocation,color: Color.fromARGB(255, 190, 192, 43), size: 19.0,),
                        Text('     Railway Road, Colombo 07.',
                          style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 17,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400),
                          ),
                      ],
                    ),
              ),
              Padding(
               padding: const EdgeInsets.only(top:20.0,left: 12,right: 12),
                child:Row(
                  mainAxisSize: MainAxisSize.min,
                  children:  const [
                    FaIcon(FontAwesomeIcons.calendar,color: Color.fromARGB(255, 190, 192, 43), size: 19.0,),
                    Text('      02/04/1998',
                      style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 17,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                      ),
                  ],
                ),
              ),
                Padding(
               padding: const EdgeInsets.only(top:20.0,left: 12,right: 12),
                child:Row(
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    const FaIcon(FontAwesomeIcons.phone,color: Color.fromARGB(255, 190, 192, 43), size: 19.0,),
                    Text("      "+'${widget.user!.mobileNo}',
                      style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 17,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                      ),
                  ],
                ),
              ),
                  ],
                ),
              
                     Padding(
                padding: const EdgeInsets.only(top: 130.0),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 200, height: 48),
                 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
