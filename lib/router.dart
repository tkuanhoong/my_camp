import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/data/repository/phone_auth_repository.dart';
import 'package:my_camp/logic/blocs/phone_auth/phone_auth_bloc.dart';
import 'package:my_camp/screens/auth/login.dart';
import 'package:my_camp/screens/auth/otp.dart';
import 'package:my_camp/screens/home.dart';
import 'package:my_camp/screens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

final PhoneAuthRepository _phoneAuthRepository = PhoneAuthRepository();
final PhoneAuthBloc _phoneAuthBloc =
    PhoneAuthBloc(phoneAuthRepository: _phoneAuthRepository);
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      name: 'welcome',
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Welcome();
      },
      // redirect: (BuildContext context, GoRouterState state) async {
      //   final SharedPreferences prefs = await SharedPreferences.getInstance();
      //   final bool? isFirstLaunched = prefs.getBool('isFirstLaunched');
      //   const bool isLoggedIn = true;
      //   if(isFirstLaunched == false){
      //     return '/';
      //   }
      //   if (isLoggedIn == false) {
      //     return '/login';
      //   }
      //   return '/home';
      // },
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
          path: 'otp/:verificationId/:phoneNumber',
          builder: (BuildContext context, GoRouterState state) {
            final String verificationId = state.params['verificationId']!;
            final String phoneNumber = state.params['phoneNumber']!;
              return BlocProvider.value(value: _phoneAuthBloc, child: Otp(verificationId: verificationId,phoneNumber: phoneNumber));
          }
        ),
        GoRoute(
          name: 'login',
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
              return BlocProvider.value(value: _phoneAuthBloc, child: const Login());
          }
        ),
      ],
    ),
  ],
);
