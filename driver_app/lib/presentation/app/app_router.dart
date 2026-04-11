import 'package:dropzone_driver_app/core/di/providers.dart';
import 'package:dropzone_driver_app/domain/entities/driver_auth_session.dart';
import 'package:dropzone_driver_app/presentation/app/app_shell.dart';
import 'package:dropzone_driver_app/presentation/auth/auth_screen.dart';
import 'package:dropzone_driver_app/presentation/home/home_screen.dart';
import 'package:dropzone_driver_app/presentation/profile/profile_screen.dart';
import 'package:dropzone_driver_app/presentation/rides/ride_detail_screen.dart';
import 'package:dropzone_driver_app/presentation/rides/rides_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authSession = ref.watch(authSessionProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isAuthRoute = location == '/auth';

      if (authSession.isLoading) {
        return isAuthRoute ? null : '/auth';
      }

      if (authSession.isAuthenticated) {
        return isAuthRoute ? '/' : null;
      }

      if (authSession.status == DriverAuthStatus.driverAccountMissing) {
        return isAuthRoute ? null : '/auth';
      }

      return isAuthRoute ? null : '/auth';
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Tab 1: Rides
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/rides',
                builder: (context, state) => const RidesScreen(),
                routes: [
                  GoRoute(
                    path: ':bookingId',
                    builder: (context, state) {
                      final bookingId =
                          int.parse(state.pathParameters['bookingId'] ?? '0');
                      return RideDetailScreen(bookingId: bookingId);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Tab 2: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
