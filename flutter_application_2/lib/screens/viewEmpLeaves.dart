import 'package:awesome_dialog/awesome_dialog.dart';
import '../screens/home.dart';
import '../components/modalWithoutImg.dart';
import '../model/empLeave.dart';
import 'package:http/http.dart' as http;
import '../screens/newEmpLeave.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../screens/updateEmpLeave.dart';
import '../components/NavDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/user.dart';

class ViewEmpLeaves extends StatefulWidget {
  static const String routeName = '/viewempleaves';
  const ViewEmpLeaves({Key? key}) : super(key: key);

  @override
  State<ViewEmpLeaves> createState() => _ViewEmpLeavesState();
}

class _ViewEmpLeavesState extends State<ViewEmpLeaves> {
  List<EmpLeave> mapEmpLeaves = [];
  final storage = const FlutterSecureStorage();
  bool isLoading = false;
  bool isAdmin = false;
  String? _userID;

  @override
  void initState() {
    super.initState();
    _check().then((_) => _getEmpLeaves());
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

  _getEmpLeaves() async {
    setState(() {
      isLoading = true;
      mapEmpLeaves.clear();
    });
    http.Response response;
    
    response = await http.get(
      Uri.parse('http://localhost:5000/leave/'));
    print(response.body);
    var jsonEmpLeave = jsonDecode(response.body);

    for (var u in jsonEmpLeave) {
      print(u["_id"]);
      EmpLeave? empLeave = EmpLeave(
        u["_id"].toString(),
        u["name"].toString(),
        u["userID"],
        u["leave_description"],
        u["leave_type"],
        u["date_time"],
      );
      mapEmpLeaves.add(empLeave);
    }
    setState(() {
      isLoading = false;
    });
  }

  deleteEmpLeave(String id) async {
    setState(() {
      isLoading = true;
    });
    print(id);
    try {
      var response = await http.delete(Uri.parse(
          'http://localhost:5000/leave/delete/$id'));
      print(response.body);
      setState(() {
        isLoading = false;
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.SCALE,
          title: 'Success',
          desc: 'Successfully Deleted',
          autoHide: const Duration(seconds: 2),
        ).show();
        _getEmpLeaves();
      });
    } catch (e) {
      print(e);
    }
  }

  create() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewEmpLeave(),
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
        title:  !isAdmin
            ? const Text(
                "My Leave Requests",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              )
            : const Text(
                "Leave Requests List",
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
          : mapEmpLeaves.isEmpty
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
                          'Empty Leaves Request',
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
                  itemCount: mapEmpLeaves.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ModalWithoutImg(
                                id: '${mapEmpLeaves[index].id}',
                                name: '${mapEmpLeaves[index].name}',
                                type: '${mapEmpLeaves[index].type}',
                                desc: '${mapEmpLeaves[index].desc}',
                                date: '${mapEmpLeaves[index].datetime}',
                                title: 'Employee Leave Details',
                              );
                            }),
                      },
                      child: Card(
                        margin: EdgeInsets.all(10),
                        child: Container(
                          height: 150,
                          color: Color.fromARGB(255, 0, 0, 0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
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
                                                child: 
                                                    isAdmin ? Row(
                                                  children: [ 
                                                    const Text(
                                                      'Employee Name : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      '${mapEmpLeaves[index].name}',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ) : null,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0,),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        'Reason : ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white),
                                                      ),
                                                      Text(
                                                        '${mapEmpLeaves[index].desc}',
                                                        style: const TextStyle(
                                                            color: Colors.white),
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
                                                          const Text(
                                                            'Type : ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Text(
                                                            '${mapEmpLeaves[index].type}',
                                                            style: const TextStyle(
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
                                                            const Text(
                                                              'Date : ',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Text(
                                                              '${mapEmpLeaves[index].datetime}',
                                                              style: const TextStyle(
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
                                                                UpdateEmpLeave(
                                                              empLeave:
                                                                  mapEmpLeaves[
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
                                                          deleteEmpLeave(
                                                              mapEmpLeaves[
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
                              )
                            ],
                          ),
                        ),
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
                child: const Text('Request Leave'),
              ),
            )
          : const Padding(padding: EdgeInsets.all(0.0)),
      drawer: NavDrawer(),
    );
  }
}
