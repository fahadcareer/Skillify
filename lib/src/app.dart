import 'dart:async';
import 'package:Skillify/src/cubit/profile/profile_cubit.dart';
import 'package:Skillify/src/cubit/register/register_cubit.dart';
import 'package:Skillify/src/provider/assesment_provider.dart';
import 'package:Skillify/src/provider/drawer_provider.dart';
import 'package:Skillify/src/provider/internet_provider.dart';
import 'package:Skillify/src/provider/language_provider.dart';
import 'package:Skillify/src/provider/profile_provider.dart';
import 'package:Skillify/src/provider/theme_provider.dart';
import 'package:Skillify/src/res/app.dart';
import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/res/drawable/drawables.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/res/style/text_style.dart';
import 'package:Skillify/src/routes/routes.dart';
import 'package:Skillify/src/services/network_services.dart';
import 'package:Skillify/src/themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:Skillify/src/services/repositoty.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final NetworkServices networkServices = NetworkServices();
    final Repository repository = Repository(networkServices: networkServices);
    return MultiBlocProvider(providers: [
      BlocProvider<RegisterCubit>(
        create: (context) => RegisterCubit(repository: repository),
      ),
      BlocProvider<ProfileCubit>(
        create: (context) => ProfileCubit(repository: repository),
      ),
      ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider()),
      ChangeNotifierProvider<DrawerProvider>(
          create: (context) => DrawerProvider()),
      ChangeNotifierProvider<InterNetProvider>(
          create: (context) => InterNetProvider()),
      ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider()),
      ChangeNotifierProvider<QuestionsProvider>(
          create: (context) => QuestionsProvider()),
      ChangeNotifierProvider<AppLanguage>(create: (context) => AppLanguage()),
    ], child: AssessmentApp());
  }
}

class AssessmentApp extends StatefulWidget {
  const AssessmentApp({super.key});

  @override
  State<AssessmentApp> createState() => _PosAppState();
}

class _PosAppState extends State<AssessmentApp> {
  bool jailbroken = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      context.read<ThemeProvider>().changeTheme();
      context.read<AppLanguage>().fetchLocale();
    });

    FlutterNativeSplash.remove();
    if (!kIsWeb) {
      requestPermission();
    }
  }

  Future<void> requestPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      debugPrint('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      debugPrint('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      debugPrint('Permission Permanently Denied');
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLanguage lp = context.watch<AppLanguage>();
    Provider.of<InterNetProvider>(context, listen: false);

    final theme = Provider.of<ThemeProvider>(context, listen: true);

    if (jailbroken) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: ThemeClass.lightTheme(theme.primaryColor),
        darkTheme: ThemeClass.darkTheme(theme.primaryColor),
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Lottie.asset(SkillAssessmentAssetsFile.error),
              ),
              Space.y0!,
              Padding(
                padding: Space.all(),
                child: textStyle(
                  text: 'This app does not support your jailbroken device.',
                  textAlign: TextAlign.center,
                  style: TextStyles.b1,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return MaterialApp.router(
      routerConfig: router,
      title: 'Skill Assessment',
      locale: lp.appLocal,
      supportedLocales: const [
        Locale('en', 'IN'),
        Locale('ar', 'AE'),
        Locale('ta', 'IN'),
      ],
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeClass.lightTheme(theme.primaryColor),
      darkTheme: ThemeClass.darkTheme(theme.primaryColor),
    );
  }
}
