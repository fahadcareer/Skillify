import 'dart:convert';
import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/widgets/cus_appbar.dart';
import 'package:Skillify/src/widgets/cus_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AssignmentDev extends StatefulWidget {
  const AssignmentDev({super.key});

  @override
  State<AssignmentDev> createState() => _AssignmentDevState();
}

class _AssignmentDevState extends State<AssignmentDev> {
  bool isLoading = false;
  List<Student> students = [];
  Student? selectedStudent;

  final TextEditingController fieldController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController certificationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNames();
  }

  Future<void> fetchNames() async {
    setState(() => isLoading = true);
    try {
      final response =
          await http.get(Uri.parse('http://20.46.197.154:5075/profiles/names'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          students = data.map((e) => Student.fromJson(e)).toList();
        });
      } else {
        throw Exception("Failed to load names");
      }
    } catch (e) {
      print("Error fetching names: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void handleSubmit() async {
    final String field = fieldController.text.trim();
    final String skills = skillsController.text.trim();
    final String certifications = certificationController.text.trim();

    if (selectedStudent == null ||
        field.isEmpty ||
        skills.isEmpty ||
        certifications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    final Map<String, dynamic> payload = {
      "name": selectedStudent!.name,
      "email": selectedStudent!.email,
      "field": field,
      "skills": skills,
      "certifications": certifications,
    };

    try {
      final response = await http.post(
        Uri.parse('http://20.46.197.154:5075/assignments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Assignment saved successfully!")),
        );
        fieldController.clear();
        skillsController.clear();
        certificationController.clear();
        setState(() => selectedStudent = null);
      } else {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed: ${json.decode(response.body)['msg']}")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(c: context, title: "Assign Skill Info"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<Student>(
                    value: selectedStudent,
                    hint: Text("Select Student", style: TextStyles.b1b!),
                    isExpanded: true,
                    items: students.map((student) {
                      return DropdownMenuItem<Student>(
                        value: student,
                        child: Text(student.name, style: TextStyles.b2!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStudent = value;
                      });
                    },
                  ),
                  Space.y1!,
                  if (selectedStudent != null) ...[
                    TextField(
                      controller: fieldController,
                      style: TextStyles.b2!,
                      decoration: InputDecoration(
                        labelText: 'Current Field',
                        labelStyle: TextStyles.b2!,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Space.y1!,
                    TextField(
                      style: TextStyles.b2!,
                      controller: skillsController,
                      decoration: InputDecoration(
                        labelText: 'Skills',
                        labelStyle: TextStyles.b2!,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    Space.y1!,
                    TextField(
                      style: TextStyles.b2!,
                      controller: certificationController,
                      decoration: InputDecoration(
                        labelText: 'Certifications',
                        labelStyle: TextStyles.b2!,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      context: context,
                      txt: "Submit",
                      txtColor: Colors.white,
                      onPressed: handleSubmit,
                    )
                  ]
                ],
              ),
      ),
    );
  }
}

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
