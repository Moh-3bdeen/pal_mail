import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pal_mail/api/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInformation{

  static Future<Map> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    http.Response response = await http.get(
      Uri.parse(ApiURLs.getUser),
      headers: {
        'Authorization': 'Bearer ${prefs.getString("userToken")}',
      },
    );

    Map result = jsonDecode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result["user"];
    }else{
      return {"message": "Error"};
    }
  }

}