import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';
import 'package:my_camp/screens/add_product_page.dart';
import 'package:my_camp/screens/auth/forgot_screen.dart';
import 'package:my_camp/screens/auth/login_screen.dart';
import 'package:my_camp/screens/auth/register_screen.dart';
import 'package:my_camp/screens/campsite_details.dart';
import 'package:my_camp/screens/campsites/update_campsite.dart';
import 'package:my_camp/screens/home.dart';
import 'package:my_camp/screens/manage_campsite.dart';
import 'package:my_camp/screens/manage_product_page.dart';
import 'package:my_camp/screens/search/search_campsite_page.dart';
import 'package:my_camp/screens/welcome.dart';
import 'package:my_camp/screens/profile_page.dart';
import 'package:my_camp/screens/campsites/create_campsite.dart';
import 'package:my_camp/screens/booking_campsite.dart';
import 'package:my_camp/screens/view_favourite_page.dart';

// final PhoneAuthBloc _phoneAuthBloc =
//     PhoneAuthBloc(phoneAuthRepository: _phoneAuthRepository);
final SessionCubit sessionCubit = SessionCubit();
final GlobalKey<NavigatorState> _navigatorState = GlobalKey<NavigatorState>();
String initialLocation = _firstScreen();

String _firstScreen() {
  // return first screen based on session
  if (sessionCubit.state.isAuthenticated == null &&
      sessionCubit.state.isFirstLaunched == null) {
    return '/welcome';
  }

  if (sessionCubit.state.isAuthenticated == null ||
      sessionCubit.state.isAuthenticated == false &&
          sessionCubit.state.isFirstLaunched == true) {
    return '/';
  }

  if (sessionCubit.state.isAuthenticated == true &&
      sessionCubit.state.isFirstLaunched == true) {
    return '/home';
  }
  return '/';
}

final GoRouter router = GoRouter(
  initialLocation: initialLocation,
  navigatorKey: _navigatorState,
  routes: <RouteBase>[
    // welcome screen
    GoRoute(
        path: '/welcome',
        builder: (BuildContext context, GoRouterState state) {
          return const Welcome();
        }),
    // auth pages
    GoRoute(
        name: 'login',
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
        routes: <RouteBase>[
          GoRoute(
              name: 'register',
              path: 'register',
              builder: (BuildContext context, GoRouterState state) {
                return const RegisterScreen();
              }),
          GoRoute(
              name: 'forgot-password',
              path: 'forgotPassword',
              builder: (BuildContext context, GoRouterState state) {
                return const ForgotScreen();
              }),
        ]),
    // app pages
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return Container();
        },
        routes: <RouteBase>[
          GoRoute(
              name: 'home',
              path: 'home',
              builder: (BuildContext context, GoRouterState state) {
                return const Home();
              },
              routes: <RouteBase>[
                GoRoute(
                    name: 'profile',
                    path: 'profile',
                    builder: (BuildContext context, GoRouterState state) {
                      return const ProfilePage();
                    }),
                GoRoute(
                    name: 'manage-campsite',
                    path: 'campsites',
                    builder: (BuildContext context, GoRouterState state) {
                      return const ManageCampsite();
                    },
                    routes: [
                      GoRoute(
                        path: 'campsite/:campsiteId',
                        name: 'campsite-details',
                        builder: (BuildContext context, GoRouterState state) {
                          return CampsiteDetails(
                              campsiteId: state.params['campsiteId']!);
                        },
                        routes: [
                          GoRoute(
                            path: "edit",
                            name: 'campsite-edit',
                            builder: (context, state) {
                              return UpdateCampsitePage(
                                  campsiteId: state.params['campsiteId']!);
                            },
                          ),
                          GoRoute(
                            path: "manageProduct",
                            name: 'campsite-manage-product',
                            builder: (context, state) {
                              return ManageProductPage(
                                  campsiteId: state.params['campsiteId']!);
                            },
                          ),
                          GoRoute(
                            path: "addProduct",
                            name: 'campsite-add-product',
                            builder: (context, state) {
                              return AddProductPage(
                                  campsiteId: state.params['campsiteId']!);
                            },
                          )
                        ],
                      ),
                      GoRoute(
                        name: 'campsites-create',
                        path: 'create',
                        builder: (BuildContext context, GoRouterState state) {
                          return const CreateCampsitePage();
                        },
                      ),
                    ]),
                GoRoute(
                  name: 'search',
                  path: 'search',
                  builder: (BuildContext context, GoRouterState state) {
                    return const SearchCampsitePage();
                  },
                ),
                GoRoute(
                  name: 'bookings',
                  path: 'bookings',
                  builder: (BuildContext context, GoRouterState state) {
                    return const BookingCampsite();
                  },
                ),
                GoRoute(
                  name: 'view-favourite',
                  path: 'favourites',
                  builder: (BuildContext context, GoRouterState state) {
                    return const ViewFavouriteCampsite();
                  },
                )
              ]),
        ]),
    // GoRoute(
    //     name: 'otp',
    //     path: '/otp/:verificationId/:phoneNumber',
    //     builder: (BuildContext context, GoRouterState state) {
    //       final String verificationId = state.params['verificationId']!;
    //       final String phoneNumber = state.params['phoneNumber']!;
    //       return BlocProvider.value(
    //           value: _phoneAuthBloc,
    //           child: Otp(
    //               verificationId: verificationId, phoneNumber: phoneNumber));
    //     }),
    // GoRoute(
    //     name: 'login',
    //     path: '/login',
    //     builder: (BuildContext context, GoRouterState state) {
    //       return RepositoryProvider.value(
    //         value: (context) => _phoneAuthRepository,
    //         child:
    //             BlocProvider.value(value: _phoneAuthBloc, child: const Login()),
    //       );
    //     }),
    // auth pages

    // GoRoute(
    //     name: 'verify-email',
    //     path: '/verifyEmail/:email',
    //     builder: (BuildContext context, GoRouterState state) {
    //       final String email = state.params['email']!;
    //       return VerifyEmailScreen(email: email);
    //     }),
  ],
  // log diagnostic info for your routes
  // debugLogDiagnostics: true,
);
