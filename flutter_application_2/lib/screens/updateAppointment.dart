import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../screens/viewAppointments.dart';
import 'package:flutter/material.dart';
import '../screens/home.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import '../model/appointment.dart';

class UpdateAppointment extends StatefulWidget {
  final Appointment? appointment;
  static const String routeName = '/updateappointment';
  UpdateAppointment({Key? key, required this.appointment}) : super(key: key);

  @override
  State<UpdateAppointment> createState() => _UpdateAppointmentState();
}

class _UpdateAppointmentState extends State<UpdateAppointment> {
  DateTime? dateTime;
  String? _name;
  String? _description;

  final _formKey = GlobalKey<FormState>();

  // String getText() {
  //   if (dateTime == null) {
  //     return 'Select DateTime';
  //   } else {
  //     return DateFormat('MM/dd/yyyy HH:mm').format(dateTime);
  //   }
  // }
  updateAppointment() async {
    var appointmentName = _name != null ? _name : widget.appointment!.name;

    var appointmentDesc =
        _description != null ? _description : widget.appointment!.desc;

    var appointmentDate =
        dateTime != null ? dateTime : widget.appointment!.datetime;

    var appointmentType = value != null ? value : widget.appointment!.type;

    print(appointmentName);
    print(appointmentDesc);
    print(appointmentType);
    print(appointmentDate);
    try {
      var response = await http.put(
          Uri.parse(
              'http://localhost:5000/appointment/update/${widget.appointment?.id}'),
          body: {
            'name': appointmentName.toString(),
            'treatment_description': appointmentDesc.toString(),
            'type': appointmentType.toString(),
            'datetime': appointmentDate.toString(),
          });
      print(response.body);
     Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const ViewAppointments()));
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        title: 'Success',
        desc: 'Successfully Updated',
        autoHide: const Duration(seconds: 2),
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: true,
        title: 'Error',
        desc: 'Cannot Update $e',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
      ).show();
      print(e);
    }
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
                    primary: Color.fromARGB(255, 255, 196, 0),
                    surface: Color.fromARGB(255, 255, 196, 0)),
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
                    primary: Color.fromARGB(255, 255, 196, 0),
                    surface: Color.fromARGB(255, 8, 8, 8)),
                dialogBackgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
              child: child!,
            ));
    if (newTime == null) return null;

    return newTime;
  }

  createUpdateAppointment() async {
    print(dateTime);
  }

  String? value;
  final items = ['Hair Style', 'Treatments', 'Hair Cut'];
  @override
  Widget build(BuildContext context) {
    {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          title: const Text(
            "Update Appointment",
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 196, 0),
        ),
        body: SingleChildScrollView(
          child: Column(
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
                            initialValue: widget.appointment?.name,
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
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
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
                            initialValue: widget.appointment?.desc,
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
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
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
                                top: 25.0, bottom: 8.0, left: 8.0, right: 8.0),
                            child: Center(
                                child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 2.0)),
                              child: DropdownButtonHideUnderline(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  child: DropdownButton<String>(
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    hint: const Text('Appointment Type',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    value: value,
                                    iconSize: 36,
                                    icon: const Icon(Icons.arrow_drop_down,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
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
                            onPressed: updateAppointment,
                            child: const Text("Update"),
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
        ),
      );
    }
  }
}
