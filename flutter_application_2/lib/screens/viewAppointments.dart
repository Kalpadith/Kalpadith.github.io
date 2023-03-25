// ignore_for_file: deprecated_member_use

import 'package:awesome_dialog/awesome_dialog.dart';
import '../screens/home.dart';
import '../screens/newAppointment.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../components/hairStyle_row.dart';
import '../screens/addHairStyle.dart';
import '../screens/updateAppointment.dart';
import '../screens/login.dart';
import '../screens/viewStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../components/modalWithoutImg.dart';
import '../model/appointment.dart';
import '../model/user.dart';
import '../service/agify.dart';
import '../components/NavDrawer.dart';
import '../screens/home.dart';

import '../screens/hairStyleList.dart';

class ViewAppointments extends StatefulWidget {
  static const String routeName = '/viewappointments';
  const ViewAppointments({Key? key}) : super(key: key);

  @override
  State<ViewAppointments> createState() => _AppointmentsListState();
}

class _AppointmentsListState extends State<ViewAppointments> {
  List<Appointment> mapAppointments = [];
  final storage = const FlutterSecureStorage();
  bool isLoading = false;
  bool isAdmin = false;
  String? _userID;

  @override
  void initState() {
    super.initState();
    _check().then((_) =>_getAppointments());
  }

  @override
  void dispose() {
    super.dispose();
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
        if (userBody.role == "0") {
          isAdmin = true;
        } else {
          isAdmin = false;
        }
      });
    }
  }

  _getAppointments() async {
    setState(() {
      isLoading = true;
      mapAppointments.clear();
    });
    print(_userID);
    print(isAdmin);
    http.Response response;
    /*if (isAdmin == true) {
      response = await http.get(Uri.parse(
          'http://localhost:5000/appointment/'));
    }*/  
      response = await http.get(Uri.parse(
          'http://localhost:5000/appointment/'));
    

    print(response.body);
    var jsonHairStyle = jsonDecode(response.body);

    for (var u in jsonHairStyle) {
      print(u["_id"]);
      Appointment? appointment = Appointment(
        u["_id"].toString(),
        u["name"].toString(),
        u["userID"],
        u["treatment_description"],
        u["type"],
        u["datetime"],
      );
      mapAppointments.add(appointment);
    }
    setState(() {
      isLoading = false;
    });
  }

  deleteHairStyle(String id) async {
    setState(() {
      isLoading = true;
    });
    print(id);
    try {
      var response = await http.delete(Uri.parse(
          'http://localhost:5000/appointment/delete/$id'));
      print(response.body);
      setState(() {
        isLoading = false;
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.SCALE,
          title: 'Scucces',
          desc: 'Scuccessfully Deleted',
          autoHide: const Duration(seconds: 2),
        ).show();
        _getAppointments();
      });
    } catch (e) {
      print(e);
    }
  }

  create() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewAppointment(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 41, 41, 41),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title: !isAdmin
            ? const Text(
                "My Appointments",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              )
            : const Text(
                "Appointments List",
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
          : mapAppointments.isEmpty
              ? Container(
                  width: double.infinity,
                  height: 300,
                  color: Color.fromARGB(0, 187, 102, 102),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: 100,
                          child: Image.asset('../assets/images/emptyList.png')),
                      const Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text(
                          'Empty Appointment',
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: mapAppointments.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ModalWithoutImg(
                                id: '${mapAppointments[index].id}',
                                name: '${mapAppointments[index].name}',
                                type: '${mapAppointments[index].type}',
                                desc: '${mapAppointments[index].desc}',
                                date: '${mapAppointments[index].datetime}',
                                title: 'Appointment Details',
                              );
                            }),
                      },
                      child: Card(
                        child: Container(
                          height: 150,
                          color: Color.fromARGB(255, 0, 0, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, left: 10.0),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child:  Row(
                                                        children: [
                                                          Text(
                                                            'Customer Name : ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Text(
                                                            '${mapAppointments[index].name}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      )
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                ),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Reason : ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        '${mapAppointments[index].desc}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Flex(
                                                  direction: Axis
                                                      .horizontal, // this is unique
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  verticalDirection:
                                                      VerticalDirection.down,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Type : ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Text(
                                                            '${mapAppointments[index].type}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 12.0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'Date : ',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Text(
                                                              '${mapAppointments[index].datetime}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            !isAdmin
                                                ? TextButton(
                                                    child: Row(
                                                      children: const [
                                                        Text(
                                                          "UPDATE",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.amber),
                                                        ),
                                                        Icon(Icons.edit,
                                                            size: 18,
                                                            color:
                                                                Colors.amber),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                UpdateAppointment(
                                                              appointment:
                                                                  mapAppointments[
                                                                      index],
                                                            ),
                                                          ));
                                                    },
                                                  )
                                                : const Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0)),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            !isAdmin
                                                ? TextButton(
                                                    child: Row(
                                                      children: const [
                                                        Text(
                                                          "DELETE",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.amber),
                                                        ),
                                                        Icon(Icons.delete,
                                                            size: 18,
                                                            color:
                                                                Colors.amber),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      AwesomeDialog(
                                                        context: context,
                                                        dialogType:
                                                            DialogType.WARNING,
                                                        headerAnimationLoop:
                                                            false,
                                                        animType:
                                                            AnimType.TOPSLIDE,
                                                        showCloseIcon: false,
                                                        title: 'Warning',
                                                        desc: 'Are your sure ?',
                                                        btnCancelOnPress: () {},
                                                        onDismissCallback:
                                                            (type) {
                                                          debugPrint(
                                                              'Dialog Dissmiss from callback $type');
                                                        },
                                                        btnOkOnPress: () {
                                                          deleteHairStyle(
                                                              mapAppointments[
                                                                      index]
                                                                  .id
                                                                  .toString());
                                                        },
                                                      ).show();
                                                    },
                                                  )
                                                : const Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0)),
                                            const SizedBox(
                                              width: 8,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                flex: 8,
                              )
                            ],
                          ),
                        ),
                        elevation: 8,
                        margin: EdgeInsets.all(10),
                      ),
                    );
                  }),
      bottomNavigationBar: !isAdmin
          ? Padding(
              padding: EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  create();
                },
                color: Colors.amber,
                textColor: Color.fromARGB(255, 0, 0, 0),
                child: Text('Add New Appointment'),
              ),
            )
          : const Padding(padding: EdgeInsets.all(0.0)),
      drawer: NavDrawer(),
    );
  }
}
