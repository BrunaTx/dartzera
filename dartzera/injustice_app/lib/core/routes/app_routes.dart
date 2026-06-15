import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/account_entity.dart';
import '../../presentation/views/about_view.dart';
import '../../presentation/views/account_create_view.dart';
import '../../presentation/views/auth/login_view.dart';
import '../../presentation/views/auth/profile_view.dart';
import '../../presentation/views/auth/sign_up_view.dart';
import '../../presentation/views/characters/list_of/characters_view.dart';
import '../../presentation/views/home_view.dart';
import '../di/dependency_injection.dart';
import '../../data/services/auth_service_interface.dart';
import 'go_router_refresh_stream.dart';

/// Route names for easier referencing
class AppRouteNames {
  static const login = 'login';
  static const signUp = 'sign_up';
  static const profile = 'profile';
  static const home = 'home';
  static const about = 'about';
  static const accountCreate = 'account_create';
  static const characters = 'characters';
}

/// Paths to keep URL structure consistent
class AppPaths {
  static const login = '/login';
  static const signUp = '/sign-up';
  static const profile = '/profile';
  static const home = '/home';
  static const about = '/about';
  static const accountCreate = '/account-create';
  static const characters = '/characters';
}

/// app routers using go_router
class AppRouter {
  AppRouter._();

  static final _authService = injector.get<IAuthService>();

  static final GoRouter router = GoRouter(
    initialLocation: AppPaths.login,
    refreshListenable: GoRouterRefreshStream(_authService.authStateChanges),
    redirect: (context, state) {
      final loggedIn = _authService.currentUser != null;
      final location = state.matchedLocation;

      final isAuthRoute =
          location == AppPaths.login || location == AppPaths.signUp;

      if (!loggedIn && !isAuthRoute) {
        return AppPaths.login;
      }

      if (loggedIn && isAuthRoute) {
        return AppPaths.home;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppPaths.login,
        name: AppRouteNames.login,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: LoginView()),
      ),
      GoRoute(
        path: AppPaths.signUp,
        name: AppRouteNames.signUp,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SignUpView()),
      ),
      GoRoute(
        path: AppPaths.profile,
        name: AppRouteNames.profile,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ProfileView()),
      ),
      GoRoute(
        path: AppPaths.home,
        name: AppRouteNames.home,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: HomeView()),
      ),
      GoRoute(
        path: AppPaths.accountCreate,
        name: AppRouteNames.accountCreate,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AccountCreateView()),
      ),
      GoRoute(
        path: AppPaths.characters,
        name: AppRouteNames.characters,
        pageBuilder: (context, state) {
          final account = state.extra;
          if (account is! Account) {
            return const NoTransitionPage(child: HomeView());
          }
          return NoTransitionPage(child: CharactersView(account: account));
        },
      ),
      GoRoute(
        path: AppPaths.about,
        name: AppRouteNames.about,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AboutView()),
      ),
    ],
  );
}
