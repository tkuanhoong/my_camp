import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camp/data/repository/auth_repository.dart';
import 'package:my_camp/logic/blocs/auth/auth_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';

class BlocWidget extends StatelessWidget {
  final Widget child;
  BlocWidget({super.key, required this.child});

  final AuthRepository _authRepository = AuthRepository();
  final AuthBloc _authBloc = AuthBloc(authRepository: AuthRepository());
  final SessionCubit _sessionCubit = SessionCubit();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: _authRepository),
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider<AuthBloc>.value(
            value: _authBloc,
          ),
          BlocProvider<SessionCubit>.value(
            value: _sessionCubit,
          ),
        ], child: child));
  }
}
