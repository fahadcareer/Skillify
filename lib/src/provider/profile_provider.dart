import 'package:Skillify/src/data/local/cache_helper.dart';
import 'package:Skillify/src/provider/Initiateassessment_provider.dart';
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

  // Add this method to convert assignment data to user profile format
  Future<void> setUserProfileFromAssignment(Assignment assignment) async {
    // Create a user profile based on the assignment data
    Map<String, dynamic> profileData = {
      "name": assignment.name,
      "age": 0, // Default as it's not in assignment data
      "highest_qualification": "", // Default as it's not in assignment data
      "current_field": assignment.field,
      "skills": assignment.skills.split(',').map((s) => s.trim()).toList(),
      "certifications":
          assignment.certifications.split(',').map((c) => c.trim()).toList(),
      "short_term_goals": "", // Default as it's not in assignment data
      "long_term_goals": "", // Default as it's not in assignment data
      "strengths": [], // Default as it's not in assignment data
      "weaknesses": [], // Default as it's not in assignment data
      "projects": [], // Default as it's not in assignment data
      "user_id": userID,
      "email": assignment.email,
      "is_manager_assessment":
          true, // Flag to indicate this is a manager assessment
    };

    // Set the user profile
    _userProfile = profileData;

    // Also load it to controllers for consistency
    loadProfileToControllers(profileData);

    notifyListeners();
  }

  Future<bool> generateAssessment() async {
    _isLoading = true;
    notifyListeners();

    try {
      // If we're not working with a manager assessment, update from controllers
      if (_userProfile['is_manager_assessment'] != true) {
        updateProfileFromControllers();
      }

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
