import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/constant/home_page_menu_items.dart';
import 'package:my_camp/logic/blocs/auth/auth_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';

import 'auth/verify_email_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildGridItem(String label, IconData icon) {
    return InkWell(
      onTap: () {
        // Handle icon tap here
        switch (label) {
          case "My Campsites":
            context.goNamed('manage-campsite');
            break;
          case "Favorites":
            // context.goNamed('manage-campsite');
                    print('Tapped on $label');
            break;
          case "My Bookings":
            // context.goNamed('booking');
            break;
          default:
        }
        print('Tapped on $label');
      },
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigo[300],
              ),
              padding: EdgeInsets.all(12.0),
              child: Icon(
                icon,
                size: 28.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String description, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.indigo[50],
      ),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.0),
          Text(
            description,
            style: TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (_, state) {
            if (state is AuthError) {
              // Displaying the error message if the user is not authenticated
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
              context.pushReplacementNamed('login');
            }
          },
          builder: (_, state) {
            if (state is VerifyingEmail) {
              return VerifyEmailScreen(email: state.email);
            }
            return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    context.goNamed('search');
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          focusNode: _focusNode,
                                          onTap: () {
                                            context.goNamed('search');
                                          },
                                          decoration: const InputDecoration(
                                            suffixIcon: Icon(Icons.search, color: Colors.grey,),
                                            hintText: 'Search',
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.person),
                              onPressed: () {
                                context.goNamed('profile');
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                16.0), // Set circular border radius
                          ),
                          color: Colors.indigo[50], // Set light grey color
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GridView.count(
                                  // crossAxisSpacing: 10,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 3,
                                  shrinkWrap: true,
                                  childAspectRatio: 1,
                                  children: [
                                    _buildGridItem('My Bookings', Icons.event),
                                    _buildGridItem(
                                        'Favorites', Icons.favorite_rounded),
                                    _buildGridItem('My Campsites', Icons.landscape),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recommended Campsites',
                              style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  // fontSize: 16,
                                  ),
                            ),
                            Row(children: const <Widget>[
                              Text('See all',
                                  style: TextStyle(
                                    // fontSize: 16,
                                    decoration: TextDecoration.underline,
                                  )),
                              Icon(Icons.arrow_forward),
                            ]),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GridView.count(
                                crossAxisSpacing: 10,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                childAspectRatio: 1.0,
                                children: [
                                  _buildCard('Campsite 1', 'Johor Bahru, Johor',
                                      'assets/images/home_campsite1.png'),
                                  _buildCard('Campsite 2', 'Perak, Ipoh',
                                      'assets/images/home_campsite2.png'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Upcoming Campsites',
                              style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  // fontSize: 16,
                                  ),
                            ),
                            Row(children: const <Widget>[
                              Text('See all',
                                  style: TextStyle(
                                    // fontSize: 16,
                                    decoration: TextDecoration.underline,
                                  )),
                              Icon(Icons.arrow_forward),
                            ]),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GridView.count(
                                crossAxisSpacing: 10,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                childAspectRatio: 1.0,
                                children: [
                                  _buildCard('Campsite 1', 'Johor Bahru, Johor',
                                      'assets/images/home_campsite1.png'),
                                  _buildCard('Campsite 2', 'Perak, Ipoh',
                                      'assets/images/home_campsite2.png'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
          },
        ),
      ),
    );
  }
}
