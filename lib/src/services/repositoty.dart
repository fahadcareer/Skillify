import 'package:Skillify/src/data/local/model/generate%20assesment/assessment_model.dart';
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

  Future<Assessment> generateAssessment(
      Map<String, dynamic> userProfile) async {
    if (networkServices == null) {
      throw Exception('Network service not initialized');
    }

    final res = await networkServices!.post(
      endPoints: NetworkString.generateAssessment,
      map: userProfile,
    );

    return Assessment.fromJson(res);
  }

  Future<Map<String, dynamic>> evaluateResponses({
    required Map<String, dynamic> assessment,
    required List<Map<String, dynamic>> userResponses,
  }) async {
    if (networkServices == null) {
      throw Exception('Network service not initialized');
    }

    final res = await networkServices!.post(
      endPoints: NetworkString.evaluateResponses,
      map: {
        "assessment": assessment,
        "user_responses": userResponses,
      },
    );

    return res;
  }
}
