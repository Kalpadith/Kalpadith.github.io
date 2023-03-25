import '../model/hairStyle.dart';
import '../screens/viewTreatment.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/treatmentGrid.dart';
import '../screens/viewStyle.dart';

class treatmentTile extends StatelessWidget {
  final Treatment treatment;
  final bool showType;
  const treatmentTile({
    Key? key,
    required this.treatment, required this.showType,
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
        builder: (context) => ViewTreatment(treatment: treatment,),
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
                child: Image.network('${treatment.image}',fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '${treatment.name}',
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
