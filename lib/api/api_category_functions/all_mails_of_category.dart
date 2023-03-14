import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pal_mail/api/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllMailsOfCategory{

  static Future<Map> getAllMailOfCategory(int catId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    http.Response response = await http.get(
      Uri.parse("${ApiURLs.allCategories}/$catId/mails"),
      headers: {
        'Authorization': 'Bearer ${prefs.getString("userToken")}',
      },
    );

    Map result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return result["category"];
    }else{
      return {"message": "Error"};
    }
  }

}