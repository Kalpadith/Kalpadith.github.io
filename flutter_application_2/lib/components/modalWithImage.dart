import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';


class ModalWithImg extends StatefulWidget {
  const ModalWithImg({ Key? key, required this.title, required this.descriptions, required this.image }) : super(key: key);
  final String title, descriptions, image;


  @override
  State<ModalWithImg> createState() => _ModalWithImgState();
}

class _ModalWithImgState extends State<ModalWithImg> {
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
           children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                child:Image.network(widget.image,fit: BoxFit.cover),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 3.0,
                      spreadRadius: 0.0,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  widget.descriptions,
                  softWrap: true,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 237, 237, 237),
                      fontSize: 15,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                ),
              ),
           
            ],
          ),
        ),
      ],
    );
  }
}