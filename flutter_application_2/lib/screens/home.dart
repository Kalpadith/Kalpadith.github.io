import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../components/hairStyleGrid.dart';
import '../components/treatmentGrid.dart';
import '../model/hairStyle.dart';
import '../service/agify.dart';
import '../components/NavDrawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  static const String routeName = '/home';

  final AgifyService _agifyService;
  const Home({Key? key})
      : _agifyService = const AgifyService(),
        super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<HairStyle> mapHairStyle = [];
  bool showType = true;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 33, 33),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("Salon UpTown",
            style: GoogleFonts.dancingScript(
                textStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 173, 167), fontSize: 30))),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
),
              child: Center(
                child: showType == false
                    ? IconButton(
                        iconSize: 20.0,
                        icon: const FaIcon(FontAwesomeIcons.stream),
                        color: const Color.fromARGB(255, 233, 232, 232),
                        onPressed: () {
                          setState(() {
                            showType = !showType;
                          });
                        },
                      )
                    : IconButton(
                        iconSize: 20.0,
                        icon: const FaIcon(FontAwesomeIcons.borderAll),
                        color: const Color.fromARGB(255, 233, 232, 232),
                        onPressed: () {
                          setState(() {
                            showType = !showType;
                          });
                          ;
                        },
                      ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                height: 40,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: const Color.fromARGB(255, 211, 74, 74),
                  ),
                  labelColor: const Color.fromARGB(255, 31, 30, 30),
                  unselectedLabelColor:
                      const Color.fromARGB(255, 228, 228, 228),
                  tabs: const [
                    // first tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Hair Style',
                    ),

                    // second tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Treatment',
                    ),
                  ],
                ),
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // first tab bar view widget
                  HairStyleGrid(showType),

                  // second tab bar view widget

                  TreatmentGrid(showType),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}
