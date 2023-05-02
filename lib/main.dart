import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camp/data/repository/phone_auth_repository.dart';
import 'package:my_camp/logic/blocs/phone_auth/phone_auth_bloc.dart';
import 'package:my_camp/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_camp/utility/app_bloc_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('isFirstLaunched');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = AppBlocObserver();
  runApp(MyCamp());
}

class MyCamp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => PhoneAuthRepository(),
      child: BlocProvider(
        create: (_) => PhoneAuthBloc(phoneAuthRepository: RepositoryProvider.of<PhoneAuthRepository>(context)),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'MyCamp - Campsite Wiki',
          theme: ThemeData(
            fontFamily: 'Poppins',
            primaryColor: Colors.indigo,
            primarySwatch: Colors.indigo,
            scaffoldBackgroundColor: Colors.white,
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
