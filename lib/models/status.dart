class Status{
  int? id;
  String? name;
  String? color;
  int? mailsCount;
  String? createdAt;
  String? updatedAt;

  Status.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    color = map['color'];
    mailsCount = int.parse(map['mails_count']);
    createdAt = map['created_at'];
    updatedAt = map['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    map['color'] = color;
    map['mails_count'] = "$mailsCount";
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}