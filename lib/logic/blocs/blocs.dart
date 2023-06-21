import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camp/data/repository/auth_repository.dart';
import 'package:my_camp/data/repository/booking_repository.dart';
import 'package:my_camp/data/repository/campsite_event_repository.dart';
import 'package:my_camp/data/repository/campsite_repository.dart';
import 'package:my_camp/data/repository/report_repository.dart';
import 'package:my_camp/data/repository/user_repository.dart';
import 'package:my_camp/logic/blocs/auth/auth_bloc.dart';
import 'package:my_camp/logic/blocs/profile/profile_bloc.dart';
import 'package:my_camp/logic/blocs/campsite/campsite_bloc.dart';
import 'package:my_camp/logic/blocs/search/search_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';

class BlocWidget extends StatelessWidget {
  final Widget child;
  BlocWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: AuthRepository()),
          RepositoryProvider.value(value: CampsiteRepository()),
          RepositoryProvider.value(value: UserRepository()),
          RepositoryProvider.value(value: CampsiteEventRepository()),
          RepositoryProvider.value(value: BookingRepository()),
          RepositoryProvider.value(value: ReportRepository())
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<SessionCubit>(
            create: (context) => SessionCubit(),
          ),
        ], child: child));
  }
}
