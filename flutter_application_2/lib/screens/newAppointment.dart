import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import '../model/user.dart';
import 'viewAppointments.dart';

class NewAppointment extends StatefulWidget {
  static const String routeName = '/newAppointment';
  NewAppointment({Key? key}) : super(key: key);

  @override
  State<NewAppointment> createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();
  DateTime? dateTime;
  String? _name;
  String? _description;
  String? _userID;
  String? value;
  String? username;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;
    print(date);
    print(time);
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
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
                    primary: Color.fromARGB(255, 211, 74, 74),
                    surface: Color.fromARGB(255, 211, 74, 74)),
                dialogBackgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
              child: child!,
            ));
    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
        context: context,
        initialTime: dateTime != null
            ? TimeOfDay(hour: dateTime!.hour, minute: dateTime!.minute)
            : initialTime,
        builder: (context, child) => Theme(
              data: ThemeData().copyWith(
                colorScheme: const ColorScheme.dark(
                    primary: Color.fromARGB(255, 211, 74, 74),
                    surface: Color.fromARGB(255, 8, 8, 8)),
                dialogBackgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
              child: child!,
            ));
    if (newTime == null) return null;

    return newTime;
  }

  createNewAppointment() async {
    print("object");
    _name ??= username;
    isLoading = true;
    try {
      var response = await http.post(
          Uri.parse(
              'http://localhost:5000/appointment/create'),
          body: {
            'name': _name,
            'userID': _userID,
            'description': _description,
            'type': value,
            'datetime': dateTime.toString(),
          });
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const ViewAppointments()));
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.SCALE,
          title: 'Scucces',
          desc: 'Scuccessfully Added',
          autoHide: const Duration(seconds: 2),
        ).show();
        isLoading = false;
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: true,
          title: 'Error',
          desc: 'Cannot Add',
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red,
        ).show();
      }
    } catch (e) {
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

  final items = ['Hair Style', 'Treatments', 'Hair Cut'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title: Text(
          "New Appointment",
          style: GoogleFonts.dancingScript(
              textStyle: const TextStyle(
                  color: Color.fromARGB(255, 21, 17, 17), fontSize: 30)),
        ),
        backgroundColor: const Color.fromARGB(255, 211, 74, 74),
      ),
      body: isLoading
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration:
                  BoxDecoration(color: Color.fromRGBO(34, 33, 33, 0.856),
                  image: DecorationImage(
                    image: const AssetImage("../assets/images/salonAppo.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.modulate),
                  )),
              child: const SpinKitFoldingCube(
                color: Color.fromARGB(255, 211, 74, 74),
              ),
            )
          : Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: const AssetImage("../assets/images/salonAppo.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.modulate),
                  )),
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
                                labelText: "Customer Name",
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
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
                              validator: (value) => (value!.isEmpty
                                  ? 'Please enter the name'
                                  : null),
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
                                labelText: "Description",
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
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
                                  return "Please enter the description";
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
                                      hint: const Text('Appointment Type',
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
                                        color: Color.fromARGB(255, 211, 74, 74),
                                        width: 2.0,
                                      ))),
                              onPressed: () {
                                pickDateTime(context);
                              },
                              child: dateTime != null
                                  ? Text(dateTime.toString())
                                  : const Text("Select DateTime"),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  createNewAppointment();
                                }
                              },
                              child: const Text("Add"),
                              style: ElevatedButton.styleFrom(
                                  primary: const Color.fromARGB(255, 211, 74, 74),
                                  onPrimary:const Color.fromARGB(255, 249, 237, 237),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  textStyle: const TextStyle(
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
