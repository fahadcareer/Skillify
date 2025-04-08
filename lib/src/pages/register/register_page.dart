import 'package:Skillify/src/cubit/register/register_cubit.dart';
import 'package:Skillify/src/cubit/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Skillify/src/res/colors/colors.dart';
import 'package:Skillify/src/res/style/text_style.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/widgets/cus_button.dart';
import 'package:Skillify/src/widgets/input_form_box.dart';
import 'package:Skillify/src/res/drawable/drawables.dart';
import 'package:Skillify/src/res/dimentions/app_dimensions.dart';
import 'package:Skillify/src/widgets/cus_svg.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;

  void _register() {
    print("_formKey: $_formKey");
    print("currentState: ${_formKey.currentState}");

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final data = {
        "email": email.text.trim(),
        "password": password.text.trim(),
        "confirm_password": confirmPassword.text.trim(),
      };

      // Call the register cubit to handle API integration
      context.read<RegisterCubit>().register(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoadingState) {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is RegisterSuccessState) {
            // Close loading dialog if open
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );

            // Navigate to login page
            context.go('/login');
          } else if (state is RegisterErrorState) {
            // Close loading dialog if open
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Space.y2!,
                  textStyle(
                    text: 'Register',
                    style: TextStyles.h2!.copyWith(color: AppColors.blackColor),
                  ),
                  textStyle(
                    text: 'Create your account to get started',
                    style: TextStyles.b2!.copyWith(color: AppColors.blackColor),
                  ),
                  Space.y1!,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle(
                        text: 'Email',
                        style: TextStyles.b3!
                            .copyWith(color: AppColors.blackColor),
                      ),
                      Space.y!,
                      CustomTextForm(
                        controller: email,
                        textCapital: TextCapitalization.none,
                        label: 'Enter email',
                        prefix: IconButton(
                          onPressed: () {},
                          icon: CustomSVG(
                            svg: SkillAssessmentAssetsFile.sms,
                            size: AppDimensions.normalize(9),
                          ),
                        ),
                        onChanged: (String value) {},
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Email cannot be empty';
                          } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(val)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      Space.y1!,
                      textStyle(
                        text: 'Password',
                        style: TextStyles.b3!
                            .copyWith(color: AppColors.blackColor),
                      ),
                      Space.y!,
                      CustomTextForm(
                        controller: password,
                        obscureText: passwordVisible,
                        label: 'Enter password',
                        onChanged: (String value) {},
                        prefix: IconButton(
                          onPressed: () {},
                          icon: CustomSVG(
                            svg: SkillAssessmentAssetsFile.pw,
                            size: AppDimensions.normalize(9),
                          ),
                        ),
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.blackColor,
                          ),
                        ),
                        validator: (val) {
                          if (val.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      Space.y1!,
                      textStyle(
                        text: 'Confirm Password',
                        style: TextStyles.b3!
                            .copyWith(color: AppColors.blackColor),
                      ),
                      Space.y!,
                      CustomTextForm(
                        controller: confirmPassword,
                        obscureText: confirmPasswordVisible,
                        label: 'Confirm password',
                        onChanged: (String value) {},
                        prefix: IconButton(
                          onPressed: () {},
                          icon: CustomSVG(
                            svg: SkillAssessmentAssetsFile.pw,
                            size: AppDimensions.normalize(9),
                          ),
                        ),
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              confirmPasswordVisible = !confirmPasswordVisible;
                            });
                          },
                          icon: Icon(
                            confirmPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.blackColor,
                          ),
                        ),
                        validator: (val) {
                          if (val != password.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      Space.y1!,
                      CustomButton(
                        context: context,
                        txt: 'Register',
                        prime: AppColors.blackColor,
                        onPressed: _register,
                      ),
                      Space.y!,
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: textStyle(
                          text: 'Already have an account? Login',
                          style: TextStyles.b2!.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
