import 'package:Skillify/src/pages/Initiate%20Assessment/Initiate_assessment.dart';
import 'package:Skillify/src/pages/profile_page.dart';
import 'package:Skillify/src/pages/profiledetailspage.dart';
import 'package:Skillify/src/services/repositoty.dart';
import 'package:go_router/go_router.dart';
import 'package:Skillify/src/pages/homepage.dart';
import 'package:Skillify/src/pages/login/login_page.dart';
import 'package:Skillify/src/pages/register/register_page.dart';
import 'package:Skillify/src/pages/assessment_page.dart';
import 'package:Skillify/src/pages/result_page.dart';
import 'package:Skillify/src/pages/404/404_page.dart';
import 'package:Skillify/src/data/local/cache_helper.dart';
import 'package:Skillify/src/services/network_services.dart';

final Repository _repository = Repository(networkServices: NetworkServices());

final GoRouter router = GoRouter(
  initialLocation: '/home',
  errorBuilder: (context, state) => const ErrorPage(),
  redirect: (context, state) async {
    final String? token = CacheHelper.getString(key: 'token');
    final String? email = CacheHelper.getString(key: 'email');
    final bool isLoggedIn = token != null && token.isNotEmpty;

    if (state.fullPath == '/login' && isLoggedIn) {
      return '/home';
    }

    if (!isLoggedIn &&
        state.fullPath != '/login' &&
        state.fullPath != '/register') {
      return '/login';
    }

    if (isLoggedIn &&
        email != null &&
        email.isNotEmpty &&
        state.fullPath == '/home') {
      try {
        final response = await _repository.getProfile(email);
        if (response['msg'] == 'Profile not found') {
          return '/profile';
        }
      } catch (e) {
        print('Error checking profile: $e');
      }
    }

    return null;
  },
  routes: <GoRoute>[
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/assessment',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return AssessmentPage(
          userProfile: extra['userProfile'],
          assessment: extra['assessment'],
        );
      },
    ),
    GoRoute(
      path: '/Initiateassessment',
      builder: (context, state) => const Initiateassessment(),
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ResultPage(
          userProfile: extra['userProfile'],
          score: extra['score'],
          result: extra['result'],
          evaluation: extra['evaluation'],
        );
      },
    ),
    GoRoute(
      path: '/profileDetails',
      builder: (context, state) => const Profiledetailspage(),
    )
  ],
);
