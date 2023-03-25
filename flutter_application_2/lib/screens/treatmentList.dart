import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
// import 'package:ctseflutter/components/treatment_row.dart';
import '../screens/addTreatment.dart';
import '../screens/updateTreatment.dart';
import '../screens/login.dart';
import '../screens/viewStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../components/modalWithImage.dart';
import '../model/treatment.dart';
import '../service/agify.dart';
import '../components/NavDrawer.dart';
import '../screens/home.dart';

import '../screens/treatmentList.dart';

class TreatmentList extends StatefulWidget {
  static const String routeName = '/treatmentlist';
  const TreatmentList({Key? key}) : super(key: key);

  @override
  State<TreatmentList> createState() => _TreatmentListState();
}

class _TreatmentListState extends State<TreatmentList> {
  List<Treatment> mapTreatment = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _getTreatment();
  }

  _getTreatment() async {
    setState(() {
      isLoading = true;
      mapTreatment.clear();
    });
    var response = await http
        .get(Uri.http('localhost:5000', '/treatment/'));
    var jsonTreatment = jsonDecode(response.body);
    print(response.body);
    for (var u in jsonTreatment) {
      print(u["_id"]);
      Treatment? treatment = Treatment(u["_id"].toString(),
          u["treatment_name"].toString(), u["treatment_description"], u["img"]);
      mapTreatment.add(treatment);
    }
    setState(() {
      isLoading = false;
    });
  }

  deleteTreatment(String id) async {
    setState(() {
      isLoading = true;
    });
    print(id);
    try {
      var response = await http.delete(Uri.parse(
          'http://localhost:5000/treatment/delete/$id'));
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
        _getTreatment();
      });
    } catch (e) {
      print(e);
    }
  }

  create() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddTreatment(),
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
        title: Text(
          "Treatment List",
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
                  const BoxDecoration(color: Color.fromRGBO(34, 33, 33, 0.856)),
              child: const SpinKitFoldingCube(
                color: Color.fromARGB(255, 211, 74, 74),
              ),
            )
          : mapTreatment.isEmpty ? Container(
                           width: double.infinity,
                          height: 300,
                          color: Color.fromARGB(0, 187, 102, 102),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            SizedBox(
                              height: 100,
                              child: Image.asset('../assets/images/emptyList.png')
                              ),
                            const Padding(
                              padding: EdgeInsets.only(top:15.0),
                              child: Text(
                                  'Empty Treatment List',
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
                          ):ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: mapTreatment.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                       onTap: () => {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return  ModalWithImg(
                                title: '${mapTreatment[index].name}',
                                descriptions:
                                    '${mapTreatment[index].desc}',
                                image: '${mapTreatment[index].image}',
                              );
                            }),
                      },
                  child: Card(
                    child: Container(
                      height: 100,
                      color: Color.fromARGB(255, 0, 0, 0),
                      child: Row(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Expanded(
                                child: Image.network(
                                    '${mapTreatment[index].image}',
                                    fit: BoxFit.cover),
                                flex: 2,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: ListTile(
                                      title: Text(
                                        '${mapTreatment[index].name}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        '${mapTreatment[index].desc}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          child: Row(
                                            children: const [
                                              Text(
                                                "UPDATE",
                                                style: TextStyle(
                                                    color: Color.fromARGB(255, 211, 74, 74)),
                                              ),
                                              Icon(Icons.edit,
                                                  size: 18, color: Color.fromARGB(255, 211, 74, 74)),
                                            ],
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateTreatment(
                                                    treatment:
                                                        mapTreatment[index],
                                                  ),
                                                ));
                                          },
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        TextButton(
                                          child: Row(
                                            children: const [
                                              Text(
                                                "DELETE",
                                                style: TextStyle(
                                                    color: Color.fromARGB(255, 211, 74, 74)),
                                              ),
                                              Icon(Icons.delete,
                                                  size: 18, color: Color.fromARGB(255, 211, 74, 74)),
                                            ],
                                          ),
                                          onPressed: () {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.WARNING,
                                              headerAnimationLoop: false,
                                              animType: AnimType.TOPSLIDE,
                                              showCloseIcon: false,
                                              title: 'Warning',
                                              desc: 'Are your sure ?',
                                              btnCancelOnPress: () {},
                                              onDismissCallback: (type) {
                                                debugPrint(
                                                    'Dialog Dissmiss from callback $type');
                                              },
                                              btnOkOnPress: () {
                                                deleteTreatment(
                                                    mapTreatment[index]
                                                        .id
                                                        .toString());
                                              },
                                            ).show();
                                          },
                                        ),
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
                          ),
                        ],
                      ),
                    ),
                    elevation: 8,
                    margin: EdgeInsets.all(10),
                  ),
                );
              }),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () {
            create();
          },
          color: Color.fromARGB(255, 211, 74, 74),
          textColor: Color.fromARGB(255, 0, 0, 0),
          child: const Text('Add a Treatment'),
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}
