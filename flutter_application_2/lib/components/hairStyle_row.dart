import '../model/hairStyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import '../screens/viewStyle.dart';

class hairStyleRow extends StatelessWidget {
  final HairStyle hairStyle;
  const hairStyleRow({
    Key? key,
    required this.hairStyle,
  }) : super(key: key);

  @override
  void initState() {
    print("yeee");
  }

  deleteHairStyle(String id) async {
    print(id);
    try {
      var response = await http.delete(Uri.parse('http://localhost:5000/hairstyle/delete/$id'));
      print(response.body);
      
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool canAddToCart = !Provider.of<CartProvider>(context).isIteamAdded(item);
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(10),
      child: Container(
        height: 100,
        color: Colors.white,
        child: Row(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Expanded(
                  child: Image.asset("assets/images/five.jpg"),
                  flex: 2,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: ListTile(
                        title: Text('${hairStyle.name}'),
                        subtitle: Text('${hairStyle.desc}'),
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
                                Text("UPDATE"),
                                Icon(
                                  Icons.edit,
                                  size: 18,
                                ),
                              ],
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          TextButton(
                            child: Row(
                              children: const [
                                Text("DELETE"),
                                Icon(
                                  Icons.delete,
                                  size: 18,
                                ),
                              ],
                            ),
                            onPressed: () {
                              deleteHairStyle(hairStyle.id.toString());
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
            ),
          ],
        ),
      ),
    );
  }
}
