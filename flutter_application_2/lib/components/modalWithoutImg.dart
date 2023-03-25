import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'constants.dart';


class ModalWithoutImg extends StatefulWidget {
  const ModalWithoutImg({ Key? key, required this.name, required this.desc, required this.type, required this.date, required this.id, required this.title }) : super(key: key);
  final String id,title,name, desc, type,date;


  @override
  State<ModalWithoutImg> createState() => _ModalWithoutImgState();
}

class _ModalWithoutImgState extends State<ModalWithoutImg> {
 @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        elevation: 0,
        backgroundColor: Color.fromARGB(0, 120, 120, 120),
        child: contentBox(context),
      ),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 450,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(top: 20,bottom: 20),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color.fromARGB(255, 58, 58, 58),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Color.fromARGB(172, 45, 45, 45),offset: Offset(0,1),
              blurRadius: 10
              ),
            ]
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
                  Padding(
                padding: const EdgeInsets.all(12),
                child:Row(
                  mainAxisSize: MainAxisSize.min,
                  children:   [
                    Text(widget.title,
                     style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                      ),
                  ],
                ),
              ),
                   Padding(
                padding: const EdgeInsets.only(top:12.0,left: 12),
                child:Row(
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    const FaIcon(FontAwesomeIcons.circle,color: Color.fromARGB(255, 229, 233, 110), size: 15.0,),
                    Text("  ID  - #"+widget.id,
                     style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                      ),
                  ],
                ),
              ),
                     Padding(
               padding: const EdgeInsets.only(top:15.0,left: 12,right: 12),
                child:Row(
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                   const FaIcon(FontAwesomeIcons.circle,color: Color.fromARGB(255, 229, 233, 110), size: 15.0,),
                    Text("  Name  -  "+widget.name,
                      style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                      ),
                  ],
                ),
              ),
                          Padding(
               padding: const EdgeInsets.only(top:15.0,left: 12,right: 12),
                child:Row(
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    const FaIcon(FontAwesomeIcons.circle,color: Color.fromARGB(255, 229, 233, 110), size: 15.0,),
                    Text("  Type -  "+widget.type,
                      style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                      ),
                  ],
                ),
              ),
                          Padding(
               padding: const EdgeInsets.only(top:15.0,left: 12,right: 12),
                child:Row(
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    const FaIcon(FontAwesomeIcons.circle,color: Color.fromARGB(255, 229, 233, 110), size: 15.0,),
                    Text("  Date -  "+widget.date,
                      style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                      ),
                  ],
                ),
              ),
                Padding(
               padding: const EdgeInsets.only(top:15.0,left: 12,right: 12),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children:  const [
                    FaIcon(FontAwesomeIcons.circle,color: Color.fromARGB(255, 229, 233, 110), size: 15.0,),
                    Text("  Description -  ",
                      style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                      ),
                  ],
                ),
              ),
                      Padding(
               padding: const EdgeInsets.only(top:6.0,left: 40,right: 22),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    Text(widget.desc,
                      style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}