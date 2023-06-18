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
  @override
  void initState() {
    _userId = context.read<SessionCubit>().state.id;
    super.initState();
  }

  Stream<List<Campsite>> getData() async* {
    final querySnapshot = await FirebaseFirestore.instance
        .collectionGroup('campsites')
        .where('favourites', arrayContains: _userId)
        .get();
    final campsitesList =
        querySnapshot.docs.map((doc) => Campsite.fromMap(doc.data())).toList();
    yield campsitesList;
  }

  @override
  void dispose() {
    _campsitesList.clear();
    super.dispose();
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
            Expanded(
              child: StreamBuilder<List<Campsite>>(
                stream: getData(),
                builder: (context, AsyncSnapshot<List<Campsite>> snapshot) {
                  if (snapshot.hasData) {
                    _campsitesList.addAll(snapshot.data!);

                    if (_campsitesList.isEmpty) {
                      return const Center(
                        child: Text('No results found'),
                      );
                    }

                    return ListView.builder(
                      itemCount: _campsitesList.length,
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
                        return SizedBox(); // Default return statement when index is out of range
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Something went wrong: ${snapshot.error}'),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
