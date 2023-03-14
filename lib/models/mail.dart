import 'package:pal_mail/models/sender.dart';

class Mail{
  String? subject;
  String? description;
  int? senderId;
  String? archiveNumber;
  String? archiveDate;
  String? decision;
  int? statusId;
  String? finalDecision;
  String? createdAt;
  String? updatedAt;
  List<int>? tags;
  List<Map<String, dynamic>>? activities;

  Mail(this.subject, this.description, this.senderId, this.archiveNumber, this.archiveDate, this.decision, this.statusId,
      this.finalDecision, this.createdAt, this.updatedAt, this.tags, this.activities);


  // Mail.fromJson(Map<String, dynamic> map) {
  //   subject = map['subject'];
  //   description = map['description'];
  //   senderId = int.parse(map['sender_id']);
  //   archiveNumber = map['archive_number'];
  //   archiveDate = map['archive_date'];
  //   decision = map['decision'];
  //   statusId = int.parse(map['status_id']);
  //   finalDecision = map['final_decision'];
  //   createdAt = map['created_at'];
  //   updatedAt = map['updated_at'];
  //   sender = Sender.fromJson(map["sender"]);
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> map = {};
  //   map['subject'] = subject;
  //   map['description'] = description;
  //   map['sender_id'] = "$senderId";
  //   map['archive_number'] = archiveNumber;
  //   map['archive_date'] = archiveDate;
  //   map['decision'] = decision;
  //   map['final_decision'] = finalDecision;
  //   map['status_id'] = "$statusId";
  //   map['created_at'] = createdAt;
  //   map['updated_at'] = updatedAt;
  //   map["sender"] = sender?.toJson();
  //   return map;
  // }

}