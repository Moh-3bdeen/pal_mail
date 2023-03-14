import 'package:http/http.dart' as http;
import 'package:pal_mail/api/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateTag {

  static Future<bool> createNewTag(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    http.Response response = await http.post(
      Uri.parse(ApiURLs.allTags),
      headers: {
        'Authorization': 'Bearer ${prefs.getString("userToken")}',
      },
      body: {
        "name": name
      }
    );

    if (response.statusCode == 200) {
      return true;
    }else{
      return false;
    }
  }

}
