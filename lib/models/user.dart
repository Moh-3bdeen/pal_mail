class User{
  int? id;
  String? name;
  String? email;
  String? image;
  String? emailVerifiedAt;
  int? roleId;
  String? createdAt;
  String? updatedAt;

  User.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    email = map['email'];
    image = map['image'];
    emailVerifiedAt = map['email_verified_at'];
    roleId = int.parse(map['role_id']);
    createdAt = map['created_at'];
    updatedAt = map['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['image'] = image;
    map['email_verified_at'] = emailVerifiedAt;
    map['role_id'] = "$roleId";
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}