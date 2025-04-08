import 'package:Skillify/src/data/local/model/login/login_model.dart';
import 'package:Skillify/src/res/strings/network_string.dart';
import 'package:Skillify/src/services/network_services.dart';

class Repository {
  final NetworkServices? networkServices;

  Repository({required this.networkServices});

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

  Future<Map<String, dynamic>> getProfile(String email) async {
    if (networkServices == null) {
      return {'msg': 'Network service not initialized'};
    }
    return await networkServices!.getProfile(email);
  }

  Future<Map<String, dynamic>> saveProfile(
      Map<String, dynamic> profileData) async {
    if (networkServices == null) {
      return {'msg': 'Network service not initialized'};
    }
    return await networkServices!.saveProfile(profileData);
  }
}
