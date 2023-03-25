import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/modalWithImage.dart';
import '../screens/home.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
// import 'package:ctseflutter/components/hairStyle_row.dart';
import '../screens/addHairStyle.dart';
import '../screens/updateHairStyle.dart';
import '../screens/login.dart';
import '../screens/viewStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../model/hairStyle.dart';
import '../service/agify.dart';
import '../components/NavDrawer.dart';
import '../screens/home.dart';

import '../screens/hairStyleList.dart';

class HairStyleList extends StatefulWidget {
  static const String routeName = '/hairstylelist';
  HairStyleList({Key? key}) : super(key: key);

  @override
  State<HairStyleList> createState() => _HairStyleListState();
}

class _HairStyleListState extends State<HairStyleList> {
  List<HairStyle> mapHairStyle = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getHairStyle();
  }

  _getHairStyle() async {
    setState(() {
      isLoading = true;
      mapHairStyle.clear();
    });
    print('h1');
    var response =
       await http.get(Uri.http('localhost:5000', '/hairstyle/'));
    var jsonHairStyle = jsonDecode(response.body);
    print('h');
    for (var u in jsonHairStyle) {
      print(u["_id"]);
      HairStyle? hairStyle = HairStyle(u["_id"].toString(),
          u["name"].toString(), u["description"], u["image"]);
      mapHairStyle.add(hairStyle);
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
      var response = await http
          .delete(Uri.parse('http://localhost:5000/hairstyle/delete/$id'));
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
        _getHairStyle();
      });
    } catch (e) {
      print(e);
    }
  }

  create() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddHairStyle(),
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
          "Hair Style List",
          style: GoogleFonts.dancingScript(
              textStyle: const TextStyle(
                  color: Color.fromARGB(255, 9, 8, 8), fontSize: 30)),
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
          : mapHairStyle.isEmpty
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
                          'Empty Hair Style List',
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
                  itemCount: mapHairStyle.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ModalWithImg(
                                title: '${mapHairStyle[index].name}',
                                descriptions: '${mapHairStyle[index].desc}',
                                image: '${mapHairStyle[index].image}',
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
                                        '${mapHairStyle[index].image}',
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
                                            '${mapHairStyle[index].name}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            '${mapHairStyle[index].desc}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              child: Row(
                                                children: const [
                                                  Text(
                                                    "UPDATE",
                                                    style: TextStyle(
                                                        color: Colors.amber),
                                                  ),
                                                  Icon(Icons.edit,
                                                      size: 18,
                                                      color: Colors.amber),
                                                ],
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateHairStyle(
                                                        hairStyle:
                                                            mapHairStyle[index],
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
                                                        color: Colors.amber),
                                                  ),
                                                  Icon(Icons.delete,
                                                      size: 18,
                                                      color: Colors.amber),
                                                ],
                                              ),
                                              onPressed: () {
                                                AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.WARNING,
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
                                                    deleteHairStyle(
                                                        mapHairStyle[index]
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
                        margin: const EdgeInsets.all(10),
                      ),
                    );
                  }),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () {
            create();
          },
          color: const Color.fromARGB(255, 211, 74, 74),
          textColor: const Color.fromARGB(255, 0, 0, 0),
          child: const Text('Add a Hair Style'),
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}
