import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/screens/auth/login.dart';
import 'package:my_camp/screens/auth/otp.dart';
import 'package:my_camp/screens/home.dart';
import 'package:my_camp/screens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Welcome();
      },
      redirect: (BuildContext context, GoRouterState state) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final bool? isFirstLaunched = prefs.getBool('isFirstLaunched');
        if (isFirstLaunched != null && isFirstLaunched == true) {
          return '/login';
        }
        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          name: 'home',
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const Home();
          },
        ),
        GoRoute(
          name: 'otp',
          path: 'otp',
          builder: (BuildContext context, GoRouterState state) {
            return const Otp();
          },
        ),
        GoRoute(
          name: 'login',
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const Login();
          },
        ),
      ],
    ),
  ],
);
