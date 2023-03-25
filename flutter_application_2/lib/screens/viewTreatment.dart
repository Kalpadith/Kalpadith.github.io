import 'dart:convert';
import '../model/hairStyle.dart';
import '../model/treatmentGrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home.dart';

import '../service/agify.dart';

class ViewTreatment extends StatefulWidget {
  static const String routeName = '/viewTreatment';
  final Treatment? treatment;
  const ViewTreatment({Key? key, required this.treatment}):
        super(key: key);

  @override
  State<ViewTreatment> createState() => _ViewTreatmentState();
}

class _ViewTreatmentState extends State<ViewTreatment> {
  _callNumber() async {
    const number = '0769733135'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    print(res);
  }

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
        title: Text(
          '${widget.treatment?.name}',
          style: const TextStyle(
              color: Color.fromARGB(255, 208, 208, 208),
              fontSize: 22,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 250,
                child: Image.network('${widget.treatment?.image}',
                    fit: BoxFit.cover),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 241, 241, 241).withOpacity(0.3),
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
                  '${widget.treatment?.name}',
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
                  '${widget.treatment?.desc}',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 240, 240, 240),
                      fontSize: 15,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 200, height: 48),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _callNumber;
                      });
                    },
                    icon: const Icon(Icons.call, size: 18),
                    label: const Text("Call Now"),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
