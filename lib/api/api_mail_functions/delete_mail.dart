import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pal_mail/api/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteMail{

  static Future<bool> deleteMail(int mailId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    http.Response response = await http.delete(
      Uri.parse("${ApiURLs.deleteMail}/$mailId"),
      headers: {
        'Authorization': 'Bearer ${prefs.getString("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      return true;
    }else{
      return false;
    }
  }

}