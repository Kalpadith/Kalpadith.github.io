import '../model/hairStyle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../screens/viewStyle.dart';

class hairStyleTile extends StatelessWidget {
  final HairStyle hairStyle;
  final bool showType;
  const hairStyleTile({
    Key? key,
    required this.hairStyle, required this.showType,
  }) : super(key: key);

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
         Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewHairStyle(hairCutView: hairStyle,),
      ))
      },
      child: Card(
        color: Color.fromARGB(255, 240, 240, 240),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.all(8.0),
        elevation: 3,
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Image.network('${hairStyle.image}',fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '${hairStyle.name}',
                   style: showType ? GoogleFonts.poppins( 
                      textStyle: const TextStyle(
                      color: Color.fromARGB(255, 27, 27, 27),
                      fontSize: 18,
                      fontWeight: FontWeight.w500)
                ):GoogleFonts.poppins( 
                      textStyle: const TextStyle(
                      color: Color.fromARGB(255, 27, 27, 27),
                      fontSize: 14,
                      fontWeight: FontWeight.w500)
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
