import 'package:Skillify/src/cubit/login/login_cubit.dart';
import 'package:Skillify/src/cubit/login/login_state.dart';
import 'package:Skillify/src/services/repositoty.dart';
import 'package:Skillify/src/services/network_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Skillify/src/data/local/cache_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:Skillify/src/res/colors/colors.dart';
import 'package:Skillify/src/res/style/text_style.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/widgets/cus_button.dart';
import 'package:Skillify/src/widgets/input_form_box.dart';
import 'package:Skillify/src/res/drawable/drawables.dart';
import 'package:Skillify/src/res/dimentions/app_dimensions.dart';
import 'package:Skillify/src/widgets/cus_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool passwordVisble = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    CacheHelper.init();
  }

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final credentials = {
        "email": email.text.trim(),
        "password": password.text.trim(),
      };

      context.read<LoginCubit>().login(credentials);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
          repository: Repository(networkServices: NetworkServices())),
      child: Scaffold(
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) async {
            if (state is LoginLoadedState) {
              await CacheHelper.saveData(
                  key: "token", value: state.loginModel.token);
              await CacheHelper.saveData(
                  key: "email", value: state.loginModel.email);
              await CacheHelper.saveData(
                  key: "role", value: state.loginModel.role);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Welcome ${state.loginModel.email}!")),
              );

              context.go('/home');
            }

            if (state is LoginErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${state.error}")),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Space.y!,
                    textStyle(text: 'Sign In', style: TextStyles.h2!),
                    textStyle(
                        text: 'Sign in to my account', style: TextStyles.b2!),
                    Space.y1!,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textStyle(text: 'Email', style: TextStyles.b3),
                        Space.y!,
                        CustomTextForm(
                          controller: email,
                          textCapital: TextCapitalization.none,
                          label: 'Enter email',
                          prefix: IconButton(
                              onPressed: () {},
                              icon: CustomSVG(
                                  svg: SkillAssessmentAssetsFile.sms,
                                  size: AppDimensions.normalize(9))),
                          onChanged: (String value) {},
                          validator: (val) {
                            if (val.length == 0) {
                              return 'Email cannot be empty';
                            } else {
                              return null;
                            }
                          },
                        ),
                        Space.y1!,
                        textStyle(text: 'Password', style: TextStyles.b3!),
                        Space.y!,
                        CustomTextForm(
                          controller: password,
                          prefix: IconButton(
                              onPressed: () {},
                              icon: CustomSVG(
                                  svg: SkillAssessmentAssetsFile.pw,
                                  size: AppDimensions.normalize(9))),
                          suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisble
                                      ? passwordVisble = false
                                      : passwordVisble = true;
                                });
                              },
                              icon: passwordVisble
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: AppColors.blackColor,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: AppColors.blackColor,
                                    )),
                          obscureText: passwordVisble,
                          keyboardType: TextInputType.visiblePassword,
                          label: 'Enter Password',
                          onChanged: (String value) {},
                          validator: (val) {
                            if (val.length == 0) {
                              return 'Password cannot be empty';
                            } else {
                              return null;
                            }
                          },
                        ),
                        Space.y!,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                context.go('/login/forget');
                              },
                              child: textStyle(
                                  text: 'Forgot Password',
                                  textAlign: TextAlign.right,
                                  style: TextStyles.b3),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Space.y1!,
                    state is LoginLoadingState
                        ? CircularProgressIndicator()
                        : CustomButton(
                            context: context,
                            txt: 'Sign In',
                            onPressed: () => _login(context),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
