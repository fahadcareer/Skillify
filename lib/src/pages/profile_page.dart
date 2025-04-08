import 'package:Skillify/src/cubit/profile/profile_cubit.dart';
import 'package:Skillify/src/cubit/profile/profile_state.dart';
import 'package:Skillify/src/widgets/cus_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Skillify/src/data/local/cache_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:Skillify/src/res/style/text_style.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/widgets/cus_button.dart';
import 'package:Skillify/src/widgets/input_form_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _educationLevelController =
      TextEditingController();
  final TextEditingController _currentFieldController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _certificationsController =
      TextEditingController();
  final TextEditingController _shortTermGoalsController =
      TextEditingController();
  final TextEditingController _longTermGoalsController =
      TextEditingController();
  final TextEditingController _strengthsController = TextEditingController();
  final TextEditingController _weaknessesController = TextEditingController();
  final TextEditingController _projectsController = TextEditingController();

  String? userEmail;
  bool isLoading = true;
  bool isProfileExist = false;

  @override
  void initState() {
    super.initState();
    userEmail = CacheHelper.getString(key: 'email');
    _loadUserProfile();
  }

  void _loadUserProfile() {
    if (userEmail != null && userEmail!.isNotEmpty) {
      context.read<ProfileCubit>().getProfile(userEmail!);
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      if (userEmail == null || userEmail!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email not found! Please log in again.")),
        );
        return;
      }
      final profileData = {
        'email': userEmail,
        'name': _nameController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'educationLevel': _educationLevelController.text,
        'currentField': _currentFieldController.text,
        'skills':
            _skillsController.text.split(',').map((e) => e.trim()).toList(),
        'certifications': _certificationsController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        'shortTermGoals': _shortTermGoalsController.text,
        'longTermGoals': _longTermGoalsController.text,
        'strengths':
            _strengthsController.text.split(',').map((e) => e.trim()).toList(),
        'weaknesses':
            _weaknessesController.text.split(',').map((e) => e.trim()).toList(),
        'projects':
            _projectsController.text.split(',').map((e) => e.trim()).toList(),
      };

      context.read<ProfileCubit>().saveProfile(profileData);
    }
  }

  void _populateForm(Map<String, dynamic> profileData) {
    _nameController.text = profileData['name'] ?? '';
    _ageController.text = (profileData['age'] ?? '').toString();
    _educationLevelController.text = profileData['educationLevel'] ?? '';
    _currentFieldController.text = profileData['currentField'] ?? '';
    _skillsController.text =
        (profileData['skills'] as List<dynamic>?)?.join(', ') ?? '';
    _certificationsController.text =
        (profileData['certifications'] as List<dynamic>?)?.join(', ') ?? '';
    _shortTermGoalsController.text = profileData['shortTermGoals'] ?? '';
    _longTermGoalsController.text = profileData['longTermGoals'] ?? '';
    _strengthsController.text =
        (profileData['strengths'] as List<dynamic>?)?.join(', ') ?? '';
    _weaknessesController.text =
        (profileData['weaknesses'] as List<dynamic>?)?.join(', ') ?? '';
    _projectsController.text =
        (profileData['projects'] as List<dynamic>?)?.join(', ') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        c: context,
        title: "Profile Page",
        backButton: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoadedState) {
            setState(() {
              isLoading = false;
              isProfileExist = true;
            });
            _populateForm(state.profile);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Profile loaded successfully!")),
            );
          } else if (state is ProfileNotFoundState) {
            setState(() {
              isLoading = false;
              isProfileExist = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please complete your profile")),
            );
          } else if (state is ProfileSavedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Profile saved successfully!")),
            );
            context.go('/home');
          } else if (state is ProfileErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoadingState && isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: textStyle(
                          text: isProfileExist
                              ? 'Update Profile'
                              : 'Complete Your Profile',
                          style: TextStyles.h2!)),
                  Center(
                      child: textStyle(
                    text: isProfileExist
                        ? 'Update your professional information'
                        : 'Please fill in your details to continue',
                    style: TextStyles.b2!,
                  )),
                  Space.y1!,
                  _buildFormField('Full Name', _nameController),
                  _buildFormField('Age', _ageController,
                      keyboardType: TextInputType.number),
                  _buildFormField('Education Level', _educationLevelController),
                  _buildFormField('Current Field', _currentFieldController),
                  _buildFormField(
                      'Skills (comma separated)', _skillsController),
                  _buildFormField('Certifications (comma separated)',
                      _certificationsController),
                  _buildFormField('Short Term Goals', _shortTermGoalsController,
                      maxLines: 3),
                  _buildFormField('Long Term Goals', _longTermGoalsController,
                      maxLines: 3),
                  _buildFormField(
                      'Strengths (comma separated)', _strengthsController),
                  _buildFormField(
                      'Weaknesses (comma separated)', _weaknessesController),
                  _buildFormField(
                      'Projects (comma separated)', _projectsController),
                  Space.y1!,
                  state is ProfileSavingState
                      ? Center(child: CircularProgressIndicator())
                      : CustomButton(
                          context: context,
                          txt: isProfileExist
                              ? 'Update Profile'
                              : 'Save Profile',
                          onPressed: _saveProfile,
                        ),
                  Space.y2!,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textStyle(text: label, style: TextStyles.b3),
        Space.y!,
        CustomTextForm(
          controller: controller,
          label: 'Enter $label',
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: (val) {
            if (val.isEmpty) {
              return '$label cannot be empty';
            }
            return null;
          },
          onChanged: (value) {},
        ),
        Space.y1!,
      ],
    );
  }
}
