import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Student {
  final String name;
  final String email;

  Student({required this.name, required this.email});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'],
      email: json['email'],
    );
  }
}

class Assignment {
  final String name;
  final String email;
  final String field;
  final List<dynamic> skills;
  final List<dynamic> certifications;

  Assignment({
    required this.name,
    required this.email,
    required this.field,
    required this.skills,
    required this.certifications,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      name: json['name'],
      email: json['email'],
      field: json['field'],
      skills: json['skills'],
      certifications: json['certifications'],
    );
  }
}

class InitiateassessmentProvider extends ChangeNotifier {
  final String namesUrl = 'http://20.46.197.154:5075/profiles/names';
  final String submitUrl = 'http://20.46.197.154:5075/assignments';
  final String fetchAssignmentUrl =
      'http://20.46.197.154:5075/assignments/email/';

  bool _isLoading = false;
  List<Student> _students = [];
  Student? _selectedStudent;
  Assignment? _currentAssignment;

  final TextEditingController fieldController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController certificationController = TextEditingController();

  bool get isLoading => _isLoading;
  List<Student> get students => _students;
  Student? get selectedStudent => _selectedStudent;
  Assignment? get currentAssignment => _currentAssignment;

  void setSelectedStudent(Student? student) {
    _selectedStudent = student;
    notifyListeners();
  }

  Future<void> fetchNames() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(namesUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _students = data.map((e) => Student.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load names");
      }
    } catch (e) {
      debugPrint("Error fetching names: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> handleSubmit() async {
    final field = fieldController.text.trim();
    final skills = skillsController.text.trim();
    final certifications = certificationController.text.trim();

    if (_selectedStudent == null ||
        field.isEmpty ||
        skills.isEmpty ||
        certifications.isEmpty) {
      return "Please fill in all fields";
    }

    final Map<String, dynamic> payload = {
      "name": _selectedStudent!.name,
      "email": _selectedStudent!.email,
      "field": field,
      "skills": skills.split(',').map((s) => s.trim()).toList(),
      "certifications": certifications.split(',').map((c) => c.trim()).toList(),
    };

    try {
      final response = await http.post(
        Uri.parse(submitUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        clearForm();
        return null;
      } else {
        final res = json.decode(response.body);
        return res['msg'] ?? 'Failed to submit';
      }
    } catch (e) {
      debugPrint("Error: $e");
      return 'Something went wrong';
    }
  }

  Future<void> fetchAssignmentByEmail(String email) async {
    _isLoading = true;
    _currentAssignment = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(fetchAssignmentUrl + email));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _currentAssignment = Assignment.fromJson(data);
      } else if (response.statusCode == 404) {
        // Not found
        throw Exception("No assessment found for this email");
      } else {
        debugPrint("Failed to fetch assignment: ${response.statusCode}");
        throw Exception("Failed to fetch assignment data");
      }
    } catch (e) {
      debugPrint("Error fetching assignment: $e");
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearForm() {
    fieldController.clear();
    skillsController.clear();
    certificationController.clear();
    _selectedStudent = null;
    notifyListeners();
  }
}
