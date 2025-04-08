class LoginModel {
  String? token;
  String? email;

  LoginModel({this.token, this.email});

  LoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['email'] = email;
    return data;
  }
}
