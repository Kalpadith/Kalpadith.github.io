import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../screens/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

import '../model/user.dart';
import 'viewEmpLeaves.dart';

class NewEmpLeave extends StatefulWidget {
  static const String routeName = '/newAppointment';
  NewEmpLeave({Key? key}) : super(key: key);

  @override
  State<NewEmpLeave> createState() => _NewEmpLeaveState();
}

class _NewEmpLeaveState extends State<NewEmpLeave> {
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();
  DateTime? dateTime;
  String? _name;
  String? _description;
  String? date;
  bool isLoading = false;
  String? _userID;
  String? value;
  String? username;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: dateTime ?? initialDate,
        firstDate: DateTime.now().subtract(const Duration(days: 0)),
        lastDate: DateTime(DateTime.now().year + 5),
        builder: (context, child) => Theme(
              data: ThemeData().copyWith(
                colorScheme: const ColorScheme.dark(
                    primary: Color.fromARGB(255, 255, 196, 0),
                    surface: Color.fromARGB(255, 255, 196, 0)),
                dialogBackgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
              child: child!,
            ));
    if (newDate == null) return null;
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedTime = DateFormat('kk:mm:a').format(newDate);
    String formattedDate = formatter.format(newDate);
    print(formattedTime);
    print(formattedDate);
    print(newDate);
    setState(() {
      date = formattedDate;
    });

    return newDate;
  }

  createNewEmpLeave() async {
    _name ??= username;
    isLoading = true;
    try {
      var response = await http.post(
          Uri.parse(
              'http://localhost:5000/leave/create'),
          body: {
            'name': _name,
            'userID': _userID,
            'description': _description,
            'type': value,
            'date_time': date,
          });
      print(response.body);
      isLoading = false;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const ViewEmpLeaves()));
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        title: 'Scucces',
        desc: 'Scuccessfully Added',
        autoHide: const Duration(seconds: 2),
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: true,
        title: 'Error',
        desc: 'Cannot Add $e',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
      ).show();
      print(e);
    }
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
        _userID = userBody.id;
        username = userBody.name;
      });
    }
  }

  final items = ['Casual', 'Medical', 'Annual'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title: const Text(
          "Request a leave",
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 196, 0),
      ),
      body: isLoading
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(34, 33, 33, 0.856)),
              child: const SpinKitFoldingCube(
                color: Color.fromARGB(255, 250, 184, 1),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 45.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Employee Name",
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the name";
                                }
                                return null;
                              },
                              initialValue: username!,
                              onChanged: (text) {
                                setState(() {
                                  _name = text;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 25.0, bottom: 8.0, left: 8.0, right: 8.0),
                            child: TextFormField(
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Reason",
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the reason";
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  _description = text;
                                });
                              },
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 25.0,
                                  bottom: 8.0,
                                  left: 8.0,
                                  right: 8.0),
                              child: Center(
                                  child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 2.0)),
                                child: DropdownButtonHideUnderline(
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    child: DropdownButton<String>(
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                      hint: const Text('Leave Type',
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      value: value,
                                      iconSize: 36,
                                      icon: const Icon(Icons.arrow_drop_down,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                      isExpanded: true,
                                      items: items.map((value) {
                                        return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                  fontFamily: "Gotham",
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ));
                                      }).toList(),
                                      onChanged: (value) =>
                                          setState(() => this.value = value),
                                    ),
                                  ),
                                ),
                              ))),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 25.0, bottom: 8.0, left: 8.0, right: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(159, 0, 0, 0),
                                  fixedSize: const Size(220, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80),
                                      side: const BorderSide(
                                        color: Color.fromARGB(255, 255, 217, 0),
                                        width: 2.0,
                                      ))),
                              onPressed: () {
                                pickDate(context);
                              },
                              child: date != null
                                  ? Text(date!)
                                  : const Text("Select Date"),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  createNewEmpLeave();
                                }
                              },
                              child: const Text("Request"),
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 245, 189, 5),
                                  onPrimary: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
    );
  }
}
