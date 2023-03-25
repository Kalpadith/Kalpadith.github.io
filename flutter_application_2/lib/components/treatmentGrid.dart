import 'dart:convert';
import '../components/hairStyle_tile.dart';
import '../screens/addHairStyle.dart';
import '../screens/viewStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../model/treatmentGrid.dart';
import '../service/agify.dart';
import '../components/NavDrawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'treatment_tile.dart';

class TreatmentGrid extends StatefulWidget {
  final bool showType;
  const TreatmentGrid(@required this.showType, {Key? key}) : super(key: key);

  @override
  State<TreatmentGrid> createState() => _TreatmentGridState();
}

class _TreatmentGridState extends State<TreatmentGrid>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Treatment> mapTreatment = [];
  bool isLoading = true;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    mapTreatment.clear();
    _getTreatment();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  _getTreatment() async {
    var response =
        await http.get(Uri.parse('http://localhost:5000/treatment/'));
    var jsonHairStyle = jsonDecode(response.body);

    for (var u in jsonHairStyle) {
      // ignore: avoid_print
      print(u["id"]);
      Treatment? treatment =
          Treatment(u["_id"], u["treatment_name"], u["treatment_description"], u["img"]);

      setState(() {
        mapTreatment.add(treatment);
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showType = widget.showType;
    return ListView(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('../assets/images/treatImg2.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.1), BlendMode.modulate),
            ),
          ),
          padding: const EdgeInsets.all(0.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                          image: AssetImage('../assets/images/treatImg2.jpg'),
                          fit: BoxFit.cover)),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(.4),
                              Colors.black.withOpacity(.2),
                            ])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const <Widget>[
                        Text(
                          "Our Treatment",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                !isLoading
                    ? mapTreatment.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            gridDelegate: showType == false
                                ? const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2)
                                : const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1),
                            itemCount: mapTreatment.length,
                            itemBuilder: (context, index) {
                              return treatmentTile(
                                treatment: mapTreatment.elementAt(index),
                                showType: showType,
                              );
                            })
                        : Container(
                            width: double.infinity,
                            height: 300,
                            color: Color.fromARGB(0, 187, 102, 102),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                    height: 115,
                                    child: Image.asset(
                                        '../assets/images/emptyState.png')),
                                const Padding(
                                  padding: EdgeInsets.only(top: 15.0),
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
                          )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 460,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(0, 227, 40, 40)),
                        child: const SpinKitFoldingCube(
                          color: Color.fromARGB(255, 211, 154, 194),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
