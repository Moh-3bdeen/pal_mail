import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api_url.dart';

class Authentication{

  static Future<bool> login(String email, String password) async {
    http.Response response = await http.post(
      Uri.parse(ApiURLs.login),
      body: {
        'email': email,
        'password': password
      },
    );

    var result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // print("Token is: ${result["token"]}");
      prefs.setString('userToken', result["token"]);

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> signUp(String name, String email, String password) async {
    http.Response response = await http.post(
      Uri.parse(ApiURLs.signup),
      body: {
        "name": name,
        'email': email,
        'password': password,
        'password_confirmation': password
      },
    );

    var result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // print("Token is: ${result["token"]}");
      prefs.setString('userToken', result["token"]);

      return true;
    } else {
      return false;
    }
  }

}