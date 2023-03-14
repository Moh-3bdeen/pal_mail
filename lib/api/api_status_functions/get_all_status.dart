import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pal_mail/api/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllStatus {

  static Future<Map?> getAllStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("User token: ${prefs.getString("userToken")}");

    http.Response response = await http.get(
      Uri.parse(ApiURLs.allStatus),
      headers: {
        'Authorization': 'Bearer ${prefs.getString("userToken")}',
      },
    );

    Map result = jsonDecode(response.body);
    // print(result);
    if (response.statusCode == 200) {
      return result;
    }else{
      return null;
    }
  }

}
