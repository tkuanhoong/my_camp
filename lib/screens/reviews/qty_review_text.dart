import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/campsite.dart';

class QtyReviewsText extends StatelessWidget {
  final String campsiteid;
  final Campsite _campsite;

  const QtyReviewsText({
    super.key,
    required Campsite campsite,
    required this.campsiteid,
  }) : _campsite = campsite;

  Stream<List<QueryDocumentSnapshot>> fetchReviews() async* {
    final campsiteSnapshot = await FirebaseFirestore.instance
        .collectionGroup('campsites')
        .where('id', isEqualTo: campsiteid)
        .get();

    if (campsiteSnapshot.docs.length > 0) {
      print('campsite exists');
      final campsiteDoc = campsiteSnapshot.docs[0];
      final reviewsSnapshot =
          await campsiteDoc.reference.collection('reviews').get();

      yield reviewsSnapshot.docs; // Return the reviews snapshot
    } else {
      print('campsite does not exist');
      yield []; // Return an empty list if the campsite document doesn't exist
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: fetchReviews(),
        builder: (BuildContext context,
            AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error fetching reviews');
          }

          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return CircularProgressIndicator(
          //     color: Colors.transparent,
          //   );
          // }
          if(snapshot.hasData){
          final reviews = snapshot.data!;
          final qtyReviews = reviews.length;

          return Text(
            '${qtyReviews} Review(s) for ${_campsite.name}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          );
          }
          return Container();
        });
  }
}
