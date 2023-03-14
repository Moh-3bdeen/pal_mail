
import 'category.dart';

class Sender{
  int? id;
  String? name;
  String? mobile;
  String? address;
  int? categoryId;
  int? mailsCount;
  String? createdAt;
  String? updatedAt;
  Category? category;

  Sender.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    mobile = map['mobile'];
    address = map['address'];
    categoryId = int.parse(map['category_id']);
    mailsCount = int.parse(map['mails_count']);
    createdAt = map['created_at'];
    updatedAt = map['updated_at'];
    category = Category.fromJson(map["category"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    map['mobile'] = mobile;
    map['address'] = address;
    map['category_id'] = "$categoryId";
    map['mails_count'] = "$mailsCount";
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['category'] = category?.toJson();
    return map;
  }

}