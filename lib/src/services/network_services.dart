import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

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
}
