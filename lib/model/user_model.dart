class UserModel {
  String? uid;
  String? email;
  String? password;

  UserModel({
    this.uid,
    this.email,
    this.password,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}