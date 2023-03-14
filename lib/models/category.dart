class Category{
  int? id;
  String? name;
  int? sendersCount;
  String? createdAt;
  String? updatedAt;

  Category.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    sendersCount = map['senders_count'];
    createdAt = map['created_at'];
    updatedAt = map['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    map['senders_count'] = sendersCount;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}