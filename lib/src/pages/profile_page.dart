import 'package:Skillify/src/provider/profile_provider.dart';
import 'package:Skillify/src/widgets/cus_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../res/dimentions/space.dart';
import '../res/style/app_typography.dart';
import '../widgets/cus_appbar.dart';
import '../widgets/cus_button.dart';
import '../widgets/input_form_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      bottomNavigationBar: CustomBottomNavigation(currentIndex: 1),
      appBar: CustomAppBar(
        c: context,
        title: "Profile Details",
        backButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Your Details',
                style: TextStyles.h2?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Space.y0!,
              _buildInputFields(profileProvider),
              Space.y0!,
              _buildSubmitButton(profileProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputFields(ProfileProvider provider) {
    final fields = [
      {'label': 'Full Name', 'controller': provider.controllers['name']},
      {
        'label': 'Age',
        'controller': provider.controllers['age'],
        'numeric': true
      },
      {
        'label': 'Education Level',
        'controller': provider.controllers['educationLevel'],
        'hint': 'e.g., High School, Undergraduate, Graduate'
      },
      {
        'label': 'Current Field',
        'controller': provider.controllers['currentField']
      },
      {
        'label': 'Skills (comma-separated)',
        'controller': provider.controllers['skills']
      },
      {
        'label': 'Certifications (comma-separated)',
        'controller': provider.controllers['certifications']
      },
      {
        'label': 'Short-term Goals',
        'controller': provider.controllers['shortTermGoals'],
        'multiline': true
      },
      {
        'label': 'Long-term Goals',
        'controller': provider.controllers['longTermGoals'],
        'multiline': true
      },
      {
        'label': 'Strengths (comma-separated)',
        'controller': provider.controllers['strengths']
      },
      {
        'label': 'Weaknesses (comma-separated)',
        'controller': provider.controllers['weaknesses']
      },
      {
        'label': 'Projects (comma-separated)',
        'controller': provider.controllers['projects']
      },
    ];

    return Column(
      children: fields
          .map((field) => Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: CustomTextForm(
                  controller: field['controller'] as TextEditingController,
                  label: field['label'] as String,
                  keyboardType: field['numeric'] == true
                      ? TextInputType.number
                      : TextInputType.text,
                  maxLines: field['multiline'] == true ? 3 : 1,
                  validator: (val) =>
                      val!.isEmpty ? '${field['label']} cannot be empty' : null,
                  onChanged: (String value) {},
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSubmitButton(ProfileProvider provider) {
    return provider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : CustomButton(
            context: context,
            txtColor: Colors.white,
            txt: 'Start Assessment',
            onPressed: () => _generateAssessment(provider),
          );
  }

  Future<void> _generateAssessment(ProfileProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await provider.generateAssessment();

    if (success && mounted) {
      context.push('/assessment', extra: {
        'userProfile': provider.userProfile,
        'assessment': provider.assessment
      });
    } else if (mounted) {
      _showErrorSnackBar('Failed to generate assessment. Please try again.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
