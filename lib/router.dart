import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import './screens/welcome.dart';
import './screens/home.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Welcome();
      },
      routes: <RouteBase>[
        GoRoute(
          name: 'home',
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const Home();
          },
        ),
      ],
    ),
  ],
);
