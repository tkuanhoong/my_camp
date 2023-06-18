import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camp/data/models/campsite.dart';
import 'package:my_camp/logic/blocs/search/search_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';
import 'package:my_camp/widgets/favourite_campsite_item.dart';
import 'package:go_router/go_router.dart';

class ViewFavouriteCampsite extends StatefulWidget {
  const ViewFavouriteCampsite({Key? key}) : super(key: key);

  @override
  State<ViewFavouriteCampsite> createState() => _ViewFavouriteCampsite();
}

class _ViewFavouriteCampsite extends State<ViewFavouriteCampsite> {
  // Query? _campsites;
  // QuerySnapshot? _querySnapshot;
  // Future<QuerySnapshot<Object?>>? _querySnapshot;
  List<Campsite> _campsitesList = [];
  String? _userId;
  Timer? _debounce;
  bool _dataFetched = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _userId = context.read<SessionCubit>().state.id;
    getData();
    if (!_dataFetched) {
      _fetchCampsites();
      _dataFetched = true;
    }
    _scrollController.addListener(() {
      _onScroll(context);
    });
    super.initState();
  }

  void getData() async {
    await FirebaseFirestore.instance
        .collectionGroup('campsites')
        .where('favourites', arrayContains: _userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Campsite campsite =
            Campsite.fromMap(doc.data() as Map<String, dynamic>);

        _campsitesList.add(campsite);
      });
    });
  }

  void _fetchCampsites() {
    context.read<SearchBloc>().add(CampsitesRequested(
        campsitesList: _campsitesList,
        keyword: _searchController.text,
        firstLoad: true,
        userId: _userId));
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {
      _onScroll(context);
    });
    _scrollController.dispose();
    _debounce?.cancel();
    _campsitesList.clear();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _campsitesList = [];
      context.read<SearchBloc>().add(CampsitesRequested(
          campsitesList: _campsitesList,
          keyword: query,
          userId: _userId,
          firstLoad: true));
    });
  }

  void _onScroll(BuildContext context) {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<SearchBloc>().add(CampsitesRequested(
          campsitesList: _campsitesList,
          keyword: _searchController.text,
          userId: _userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              leading: const BackButton(),
              title: const Text('My Favourite Campsites'),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       BackButton(
            //         color: Theme.of(context).primaryColor,
            //       ),
            //       Expanded(
            //         child: TextFormField(
            //           onChanged: _onSearchChanged,
            //           controller: _searchController,
            //           decoration: InputDecoration(
            //             hintText: 'Search for campsites',
            //             border: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(8.0),
            //             ),
            //             contentPadding: const EdgeInsets.symmetric(
            //               vertical: 12.0, // Adjust the vertical padding here
            //               horizontal: 16.0,
            //             ),
            //             suffixIcon: const Icon(Icons.search),
            //           ),
            //         ),
            //       ),
            //       IconButton(
            //         icon: const Icon(Icons.add),
            //         onPressed: () {
            //           context.goNamed('campsites-create');
            //           // context.pushReplacementNamed('campsites-create');
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SearchResultLoaded) {
                  // const firstLoadItemLength = 10;
                  // if ((state.searchResults.isNotEmpty &&
                  //         _campsitesList.isEmpty) ||
                  //     (state.searchAction &&
                  //         _campsitesList.isEmpty &&
                  //         state.searchResults.isNotEmpty)) {
                  //   _campsitesList = state.searchResults;
                  // } else {
                  //   if (_campsitesList.isNotEmpty &&
                  //       state.searchResults.isNotEmpty &&
                  //       _campsitesList.last.id != state.searchResults.last.id) {
                  //     _campsitesList = [
                  //       ..._campsitesList,
                  //       ...state.searchResults
                  //     ];
                  //   }
                  // }

                  print('xxxxxx');
                  // print(_fetchSingleCampsiteData());
                  // _campsitesList = _fetchSingleCampsiteData();

                  // FirebaseFirestore.instance
                  //     .collectionGroup('campsites')
                  //     .get()
                  //     .then((QuerySnapshot querySnapshot) {
                  //   querySnapshot.docs.forEach((doc) {
                  //     Campsite campsite =
                  //         Campsite.fromMap(doc.data() as Map<String, dynamic>);

                  //     _campsitesList.add(campsite);
                  //   });
                  // });
                  print(_campsitesList);
                  // print(x);
                  print('xxxxxx');

                  if (_campsitesList.isEmpty) {
                    return const Center(
                      child: Text('No results found'),
                    );
                  }
                  return ListView.builder(
                    // controller: _scrollController,
                    // itemCount: (state.hasReachedMax ||
                    //         _campsitesList.length < firstLoadItemLength)
                    //     ? _campsitesList.length
                    //     : _campsitesList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < _campsitesList.length) {
                        return FavouriteCampsiteItem(
                          id: _campsitesList[index].id,
                          imagePath: _campsitesList[index].imagePath,
                          description: _campsitesList[index].state,
                          starRating: 5,
                          title: _campsitesList[index].name,
                        );
                      }
                    },
                    // itemBuilder: (context, index) {
                    //   return index >= _campsitesList.length
                    //       ? const Center(
                    //           child: Padding(
                    //             padding: EdgeInsets.all(4.0),
                    //             child: SizedBox(
                    //               height: 30,
                    //               width: 30,
                    //               child: CircularProgressIndicator(),
                    //             ),
                    //           ),
                    //         )
                    //       : CampsiteItem(
                    //           id: _campsitesList[index].id,
                    //           imagePath: _campsitesList[index].imagePath,
                    //           description: _campsitesList[index].state,
                    //           starRating: 5,
                    //           title: _campsitesList[index].name,
                    //         );
                    // },
                  );
                }
                return const Center(
                  child: Text('Something went wrong'),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class ViewFavouriteCampsite extends StatelessWidget {
//   const ViewFavouriteCampsite({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0XFF3F3D56),
//         leading: const IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//           ),
//           tooltip: 'Navigation menu',
//           onPressed: null,
//         ),
//         title: const Text('[Favourite Page]'),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 children: [
//                   _buildCampsiteListView('Campsite 1', 'Skudai, Johor', 4),
//                   _buildCampsiteListView('Campsite 2', 'Bangi, Selangor', 3),
//                   _buildCampsiteListView(
//                       'Campsite 3', 'Bukit Gajah, Melaka', 5),
//                   _buildCampsiteListView('Campsite 4', 'Genting Highlands', 2),
//                   _buildCampsiteListView('Campsite 5', 'Georgetown, Penang', 5),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCampsiteListView(
//       String title, String description, double starRating) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.grey[600]!,
//           width: 1.0,
//         ),
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: SizedBox(
//         height: 130.0, // Adjust the desired height of the ListTile
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(
//                   8.0), // Add desired padding around the image
//               width: 150.0, // Adjust the width of the image container
//               child: Image.asset(
//                 'assets/images/camp.jpg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0), // Add desired padding
//                 child: ListTile(
//                   contentPadding: const EdgeInsets.all(
//                       8.0), // Set the same padding value for the text content
//                   title: Text(
//                     title,
//                     style: const TextStyle(
//                         color: Colors.black,
//                         fontWeight:
//                             FontWeight.bold // Replace with your desired color
//                         ),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 5.0),
//                       Text(description),
//                       const SizedBox(height: 5.0),
//                       Row(
//                         children: [
//                           const Icon(Icons.star, color: Colors.yellow),
//                           const SizedBox(
//                               width:
//                                   4.0), // Add spacing between the icon and the rating text
//                           Text(
//                             starRating.toStringAsFixed(1),
//                             style: const TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight
//                                     .w500 // Replace with your desired color
//                                 ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
