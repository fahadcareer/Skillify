class LoginModel {
  String? token;
  String? email;
  int? role;

  LoginModel({this.token, this.email});

  LoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    email = json['email'];
    role = json['role'] ?? 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['email'] = email;
    data['role'] = role;
    return data;
  }
}
