import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:Skillify/src/res/strings/network_string.dart';

class NetworkServices {
  //--------- POST Method ---------------------------------
  Future<dynamic> post({
    required String endPoints,
    required Map<String, dynamic> map,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(endPoints),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(map),
      );

      log("POST Response: ${response.body}");

      return json.decode(response.body);
    } catch (e) {
      log('POST Error: $e');
      return e.toString();
    }
  }

  //--------- GET Method ---------------------------------
  Future<dynamic> get({
    required String endPoints,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(endPoints),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      log("GET Response: ${response.body}");

      return json.decode(response.body);
    } catch (e) {
      log('GET Error: $e');
      return e.toString();
    }
  }

  //--------- Profile Methods ---------------------------------
  Future<Map<String, dynamic>> getProfile(String email) async {
    try {
      final response = await get(
        endPoints: "${NetworkString.baseURL}/profile/$email",
      );

      if (response is String) {
        return {'msg': 'Request failed: $response'};
      }

      return response;
    } catch (e) {
      log('Get Profile Error: $e');
      return {'msg': 'Profile not found'};
    }
  }

  Future<Map<String, dynamic>> saveProfile(
      Map<String, dynamic> profileData) async {
    try {
      final response = await post(
        endPoints: "${NetworkString.baseURL}/profile",
        map: profileData,
      );

      if (response is String) {
        return {'msg': 'Request failed: $response'};
      }

      return response;
    } catch (e) {
      log('Save Profile Error: $e');
      return {
        'msg': 'Failed to save profile: $e'
      };  
    }
  }
}
