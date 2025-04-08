import 'package:go_router/go_router.dart';
import 'package:Skillify/src/pages/homepage.dart';
import 'package:Skillify/src/pages/login/login_page.dart';
import 'package:Skillify/src/pages/register/register_page.dart';
import 'package:Skillify/src/pages/profile_page.dart';
import 'package:Skillify/src/pages/assessment_page.dart';
import 'package:Skillify/src/pages/result_page.dart';
import 'package:Skillify/src/pages/404/404_page.dart';
import 'package:Skillify/src/data/local/cache_helper.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  errorBuilder: (context, state) => const ErrorPage(),
  redirect: (context, state) {
    final String? token = CacheHelper.getString(key: 'token');
    final bool isLoggedIn = token != null && token.isNotEmpty;
    if (state.fullPath == '/login' && isLoggedIn) {
      return '/home';
    }
    if (!isLoggedIn &&
        state.fullPath != '/login' &&
        state.fullPath != '/register') {
      return '/login';
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
  ],
);
