import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dropzone_app/presentation/booking_flow/booking_flow_screen.dart';
import 'package:dropzone_app/presentation/home/home_screen.dart';
import 'package:dropzone_app/presentation/app/main_shell.dart';
import 'package:dropzone_app/presentation/profile/profile_screen.dart';
import 'package:dropzone_app/presentation/auth/auth_screen.dart';
import 'package:dropzone_app/presentation/auth/otp_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthScreen(),
      routes: [
        GoRoute(
          path: 'otp',
          name: 'otp',
          builder: (context, state) => const OtpScreen(),
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/book',
          name: 'book',
          builder: (context, state) => const BookingFlowScreen(),
        ),
        GoRoute(
          path: '/bookings',
          name: 'bookings',
          builder: (context, state) => const PlaceholderScreen(title: 'Bookings'),
        ),
        GoRoute(
          path: '/support',
          name: 'support',
          builder: (context, state) => const PlaceholderScreen(title: 'Support'),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Coming soon',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
