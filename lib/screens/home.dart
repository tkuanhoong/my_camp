import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/screens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget buildGridItem(String label, IconData icon) {
    return InkWell(
      onTap: () {
        // Handle icon tap here
        print('Tapped on $label');
      },
      child: Container(
        // decoration: BoxDecoration(
        //   shape: BoxShape.circle,
        //   border: Border.all(color: Colors.grey),
        // ),
        padding: EdgeInsets.all(0),
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
            SizedBox(height: 8.0),
            Text(label, style: TextStyle(fontSize: 12)),
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                focusNode: _focusNode,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        //Change Welcome to search page
                                        builder: (context) => Welcome()),
                                  );
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      //Change Welcome to search page
                                      builder: (context) => Welcome()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {
                        Navigator.push(
                          context,
                          // change Welcome to profile page
                          MaterialPageRoute(builder: (context) => Welcome()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
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
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          childAspectRatio: 1,
                          children: [
                            buildGridItem('My Bookings', Icons.event),
                            buildGridItem('My Campsites', Icons.landscape),
                            buildGridItem('Favorites', Icons.favorite_rounded),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommended Campsites',
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          // fontSize: 16,
                          ),
                    ),
                    Row(children: [
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
//////////////////////////////////////////////////
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisSpacing: 10,
                        physics: NeverScrollableScrollPhysics(),
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

              // Row(
              //   children: [
              //     Expanded(
              //       child: Padding(
              //         padding: EdgeInsets.fromLTRB(20, 20, 10, 0),
              //         child: Column(
              //           children: [
              //             InkWell(
              //               onTap: () {},
              //               child: SizedBox(
              //                 // width: 80,
              //                 // height: 80,
              //                 child: ClipRRect(
              //                   borderRadius: BorderRadius.circular(5),
              //                   child: Image.asset(
              //                     'assets/images/home_campsite1.png',
              //                     fit: BoxFit.cover,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: Padding(
              //         padding: EdgeInsets.fromLTRB(10, 20, 20, 0),
              //         child: Column(
              //           children: [
              //             InkWell(
              //               onTap: () {},
              //               child: SizedBox(
              //                 // width: 80,
              //                 // height: 80,
              //                 child: ClipRRect(
              //                   borderRadius: BorderRadius.circular(5),
              //                   child: Image.asset(
              //                     'assets/images/home_campsite2.png',
              //                     fit: BoxFit.cover,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
///////////////////////////////////////////////////////////
              Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Campsites',
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          // fontSize: 16,
                          ),
                    ),
                    Row(children: [
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
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisSpacing: 10,
                        physics: NeverScrollableScrollPhysics(),
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
              // Row(
              //   children: [
              //     Expanded(
              //       child: Padding(
              //         padding: EdgeInsets.fromLTRB(20, 20, 10, 0),
              //         child: Column(
              //           children: [
              //             InkWell(
              //               onTap: () {},
              //               child: SizedBox(
              //                 // width: 80,
              //                 // height: 80,
              //                 child: ClipRRect(
              //                   borderRadius: BorderRadius.circular(5),
              //                   child: Image.asset(
              //                     'assets/images/home_campsite1.png',
              //                     fit: BoxFit.cover,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: Padding(
              //         padding: EdgeInsets.fromLTRB(10, 20, 20, 0),
              //         child: Column(
              //           children: [
              //             InkWell(
              //               onTap: () {},
              //               child: SizedBox(
              //                 // width: 80,
              //                 // height: 80,
              //                 child: ClipRRect(
              //                   borderRadius: BorderRadius.circular(5),
              //                   child: Image.asset(
              //                     'assets/images/home_campsite2.png',
              //                     fit: BoxFit.cover,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.favorite),
      //       label: 'Favourites',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      //   currentIndex: 0,
      //   onTap: (int index) {},
      // ),
    );
  }
}
