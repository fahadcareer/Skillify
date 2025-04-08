import 'package:Skillify/src/data/local/model/login/login_model.dart';
import 'package:Skillify/src/res/strings/network_string.dart';
import 'package:Skillify/src/services/network_services.dart';

class Repository {
  final NetworkServices? networkServices;

  Repository({this.networkServices});

  Future<LoginModel> login(Map<String, dynamic> req) async {
    final loginRes =
        await networkServices!.post(endPoints: NetworkString.login, map: req);
    return LoginModel.fromJson(loginRes);
  }

  Future<dynamic> register(Map<String, dynamic> req) async {
    final registerRes = await networkServices!
        .post(endPoints: NetworkString.register, map: req);
    return registerRes;
  }
}
