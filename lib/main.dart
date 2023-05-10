import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_camp/logic/blocs/blocs.dart';
import 'package:my_camp/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_camp/utility/app_bloc_observer.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  // HydratedBloc.storage.clear();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = AppBlocObserver();
  SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
  ]);
  runApp(MyCamp());
}

class MyCamp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocWidget(
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
    );
  }
}
