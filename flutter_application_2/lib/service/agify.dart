import 'dart:convert';
import 'package:http/http.dart';

class AgifyService {
  static const String endpoint = "http://localhost:5000/hairstyle";
  const AgifyService();

  Future<int?> getAgeFromName(String name) async {
    Response response = await get(
      Uri.parse(endpoint).replace(
        queryParameters: {
          "name": name,
        },
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['age'];
    }
    throw Exception("Error in getting the age");
  }


  Future getHairStyle( ) async {
    Response response = await get(
      Uri.parse(endpoint).replace(
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Error in getting the age");
  }
}
