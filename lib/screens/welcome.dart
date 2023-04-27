import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/constant/welcome_page_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  double? currentPage = 0.0;
  bool lastPage = false;
  List<Widget> slides = items
      .map((item) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Image.asset(
                  item['image'],
                  fit: BoxFit.fitWidth,
                  width: 220.0,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(item['header'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              letterSpacing: 1.5,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0XFF3F3D56),
                              height: 1.0)),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        item['description'],
                        style: const TextStyle(
                            color: Colors.grey,
                            letterSpacing: 1.2,
                            fontSize: 16.0,
                            height: 1.3),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            ],
          )))
      .toList();
  List<Widget> indicator() => List<Widget>.generate(
      slides.length,
      (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
                color: currentPage?.round() == index
                    ? const Color(0XFF256075)
                    : const Color(0XFF256075).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0)),
          ));
  final _pageViewController = PageController();
  // code getter for shared preference
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> _setFirstLaunched() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('isFirstLaunched', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageViewController,
              itemCount: slides.length,
              itemBuilder: (BuildContext context, int index) {
                _pageViewController.addListener(() {
                  setState(() {
                    currentPage = _pageViewController.page;
                    lastPage = currentPage! > slides.length - 1.2;
                  });
                });
                return slides[index];
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (lastPage)
                  AnimatedOpacity(
                    opacity: currentPage == slides.length - 1 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 101.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        onPressed: () async {
                          context.replaceNamed('login');
                          await _setFirstLaunched();
                        },
                        child: const Text('Get Started!')),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicator(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
