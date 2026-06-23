import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../logic/auth/auth_cubit.dart';
import '../../logic/auth/auth_state.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/partner/partner_share_screen.dart';
import '../screens/partner/partner_view_screen.dart';

GoRouter createRouter(AuthCubit authCubit) {
  return GoRouter(
    refreshListenable: _AuthListener(authCubit),
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final authState = authCubit.state;
      final isAuth = authState.status == AuthStatus.authenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isAuth && !isAuthRoute) return '/login';
      if (isAuth && isAuthRoute) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (_, _) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/partner/share',
        builder: (_, _) => const PartnerShareScreen(),
      ),
      GoRoute(
        path: '/partner/view',
        builder: (_, _) => const PartnerViewScreen(),
      ),
    ],
  );
}

class _AuthListener extends ChangeNotifier {
  final AuthCubit _cubit;

  _AuthListener(this._cubit) {
    _cubit.stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
}
