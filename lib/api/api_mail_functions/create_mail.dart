import 'package:http/http.dart' as http;
import 'package:pal_mail/api/api_url.dart';
import 'package:pal_mail/models/mail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateMail {
  static Future<bool> createNewMail(
      String subject,
      String description,
      int senderId,
      String archiveNumber,
      String archiveDate,
      String decision,
      int statusId,
      String? finalDecision,
      List<int> tags,
      List<Map<String, dynamic>> activities) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    http.Response response =
        await http.post(Uri.parse(ApiURLs.createMail), headers: {
      'Authorization': 'Bearer ${prefs.getString("userToken")}',
    }, body: {
      "subject": subject,
      "description": description,
      "sender_id": senderId,
      "archive_number": archiveNumber,
      "archive_date": archiveDate,
      "decision": decision,
      "status_id": statusId,
      "final_decision": finalDecision,
      "tags": tags,
      "activities": activities,
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
