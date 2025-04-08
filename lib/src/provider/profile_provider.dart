import 'package:Skillify/src/data/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileProvider extends ChangeNotifier {
  final String assessmentBaseUrl =
      'http://20.46.197.154:5075/generate-assessment';

  Map<String, dynamic> _userProfile = {};
  Map<String, dynamic> _assessment = {};
  bool _isLoading = false;
  final String userID = CacheHelper.getString(key: 'userID');

  Map<String, dynamic> get userProfile => _userProfile;
  Map<String, dynamic> get assessment => _assessment;
  bool get isLoading => _isLoading;

  final controllers = <String, TextEditingController>{
    'name': TextEditingController(),
    'age': TextEditingController(),
    'educationLevel': TextEditingController(),
    'currentField': TextEditingController(),
    'skills': TextEditingController(),
    'certifications': TextEditingController(),
    'shortTermGoals': TextEditingController(),
    'longTermGoals': TextEditingController(),
    'strengths': TextEditingController(),
    'weaknesses': TextEditingController(),
    'projects': TextEditingController(),
  };

  void reset() {
    _userProfile = {};
    _assessment = {};
    _isLoading = false;

    controllers.forEach((key, controller) {
      controller.clear();
    });

    notifyListeners();
  }

  void updateProfileFromControllers() {
    _userProfile = {
      "name": controllers['name']!.text,
      "age": int.tryParse(controllers['age']!.text) ?? 0,
      "highest_qualification": controllers['educationLevel']!.text,
      "current_field": controllers['currentField']!.text,
      "skills":
          controllers['skills']!.text.split(',').map((s) => s.trim()).toList(),
      "certifications": controllers['certifications']!
          .text
          .split(',')
          .map((s) => s.trim())
          .toList(),
      "short_term_goals": controllers['shortTermGoals']!.text,
      "long_term_goals": controllers['longTermGoals']!.text,
      "strengths": controllers['strengths']!
          .text
          .split(',')
          .map((s) => s.trim())
          .toList(),
      "weaknesses": controllers['weaknesses']!
          .text
          .split(',')
          .map((s) => s.trim())
          .toList(),
      "projects": controllers['projects']!
          .text
          .split(',')
          .map((s) => s.trim())
          .toList(),
      "user_id": userID,
    };

    notifyListeners();
  }

  void loadProfileToControllers(Map<String, dynamic> profile) {
    controllers['name']!.text = profile['name'] ?? '';
    controllers['age']!.text = profile['age']?.toString() ?? '';
    controllers['educationLevel']!.text =
        profile['highest_qualification'] ?? '';
    controllers['currentField']!.text = profile['current_field'] ?? '';
    controllers['skills']!.text = profile['skills']?.join(', ') ?? '';
    controllers['certifications']!.text =
        profile['certifications']?.join(', ') ?? '';
    controllers['shortTermGoals']!.text = profile['short_term_goals'] ?? '';
    controllers['longTermGoals']!.text = profile['long_term_goals'] ?? '';
    controllers['strengths']!.text = profile['strengths']?.join(', ') ?? '';
    controllers['weaknesses']!.text = profile['weaknesses']?.join(', ') ?? '';
    controllers['projects']!.text = profile['projects']?.join(', ') ?? '';

    _userProfile = profile;
    notifyListeners();
  }

  bool isProfileValid() {
    return controllers['name']!.text.isNotEmpty &&
        controllers['age']!.text.isNotEmpty &&
        controllers['educationLevel']!.text.isNotEmpty;
  }

  Future<bool> generateAssessment() async {
    _isLoading = true;
    notifyListeners();

    try {
      updateProfileFromControllers();

      final response = await http.post(
        Uri.parse(assessmentBaseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_userProfile),
      );

      if (response.statusCode == 200) {
        _assessment = json.decode(response.body);
        // final responseJson = json.decode(response.body);
        // print('Error message: ${responseJson['error'] ?? 'No detailed error'}');

        notifyListeners();
        return true;
      } else {
        print('Failed to generate assessment: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error generating assessment: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void saveAssessment(Map<String, dynamic> assessmentData) {
    _assessment = assessmentData;
    notifyListeners();
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }
}
