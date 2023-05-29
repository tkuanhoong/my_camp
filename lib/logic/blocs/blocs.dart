import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camp/data/repository/auth_repository.dart';
import 'package:my_camp/data/repository/campsite_repository.dart';
import 'package:my_camp/data/repository/user_repository.dart';
import 'package:my_camp/logic/blocs/auth/auth_bloc.dart';
import 'package:my_camp/logic/blocs/bloc/profile_bloc.dart';
import 'package:my_camp/logic/blocs/campsite/campsite_bloc.dart';
import 'package:my_camp/logic/blocs/search/search_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';

class BlocWidget extends StatelessWidget {
  final Widget child;
  BlocWidget({super.key, required this.child});

  final AuthRepository _authRepository = AuthRepository();
  final AuthBloc _authBloc = AuthBloc(authRepository: AuthRepository());
  final SessionCubit _sessionCubit = SessionCubit();
  final CampsiteRepository _campsiteRepository = CampsiteRepository();
  final SearchBloc _searchBloc = SearchBloc(repository: CampsiteRepository());
  final CampsiteBloc _campsiteBloc = CampsiteBloc();
  final UserRepository _userRepository = UserRepository();
  final ProfileBloc _profileCubit = ProfileBloc(userRepository: UserRepository());

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: _authRepository),
          RepositoryProvider.value(value: _campsiteRepository),
          RepositoryProvider.value(value: _userRepository)
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider<AuthBloc>.value(
            value: _authBloc,
          ),
          BlocProvider<SessionCubit>.value(
            value: _sessionCubit,
          ),
          BlocProvider<SearchBloc>.value(
            value: _searchBloc,
          ),
          BlocProvider<CampsiteBloc>.value(
            value: _campsiteBloc,
          ),
          BlocProvider.value(value: _profileCubit)
        ], child: child));
  }
}
