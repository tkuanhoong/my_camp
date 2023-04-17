import 'package:flutter/material.dart';
import 'package:my_camp/router.dart';

void main() => runApp(MyCamp());

class MyCamp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MyCamp - Campsite Wiki',
      theme: ThemeData(
      fontFamily: 'Poppins',
      primaryColor: Colors.indigo,
      primarySwatch: Colors.indigo,
      scaffoldBackgroundColor: Colors.white,
      ),
      routerConfig: router,
    );
  }
}
