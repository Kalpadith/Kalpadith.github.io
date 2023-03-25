import 'dart:convert';
import '../model/hairStyle.dart';
import '../screens/addHairStyle.dart';
import '../screens/viewStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../model/hairStyle.dart';
import 'hairStyle_tile.dart';

class HairStyleGrid extends StatefulWidget {
  final bool showType;
  const HairStyleGrid(this.showType, {Key? key}) : super(key: key);

  @override
  State<HairStyleGrid> createState() => _HairStyleGridState();
}

class _HairStyleGridState extends State<HairStyleGrid>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<HairStyle> mapHairStyle = [];
  bool isLoading = true;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    mapHairStyle.clear();
    _getHairStyle();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  _getHairStyle() async {
    var response =
        await http.get(Uri.parse('http://localhost:5000/hairstyle/'));
    var jsonHairStyle = jsonDecode(response.body);

    for (var u in jsonHairStyle) {
      print(u["id"]);
      HairStyle? hairStyle =
          HairStyle(u["_id"], u["name"], u["description"], u["image"]);

      setState(() {
        mapHairStyle.add(hairStyle);
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
              image: const AssetImage('../assets/images/cardImg4.jpg'),
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
                          image: AssetImage('../assets/images/cardImg4.jpg'),
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
                          "Our Hairstyles",
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
                    ? mapHairStyle.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            gridDelegate: showType == true
                                ? const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2)
                                : const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1),
                            itemCount: mapHairStyle.length,
                            itemBuilder: (context, index) {
                              return hairStyleTile(
                                hairStyle: mapHairStyle.elementAt(index),
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
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 460,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(0, 34, 33, 33)),
                        child: const SpinKitFoldingCube(
                          color: Color.fromARGB(255, 250, 184, 1),
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
