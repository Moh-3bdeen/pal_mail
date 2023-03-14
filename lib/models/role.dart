class Role {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? usersCount;


  Role.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    createdAt = map['created_at'];
    updatedAt = map['updated_at'];
    usersCount = int.parse(map['users_count']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['users_count'] = "$usersCount";
    return map;
  }
}
