import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pal_mail/api/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllCategories{

  static Future<Map> getAllCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("User token: ${prefs.getString("userToken")}");

    http.Response response = await http.get(
      Uri.parse(ApiURLs.allCategories),
      headers: {
        'Authorization': 'Bearer ${prefs.getString("userToken")}',
      },
    );

    Map result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // return all category, and in each category we can get all senders
      return result;
    }else{
      return {"message": "Error"};
    }
  }

}