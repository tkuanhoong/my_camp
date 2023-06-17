import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AverageRatingText extends StatelessWidget {
  final String campsiteid;

  const AverageRatingText({
    super.key,
    required this.campsiteid,
  });

  Future<List<QueryDocumentSnapshot>> fetchReviews() async {
    final campsiteSnapshot = await FirebaseFirestore.instance
        .collectionGroup('campsites')
        .where('id', isEqualTo: campsiteid)
        .get();

    if (campsiteSnapshot.docs.length > 0) {
      print('campsite exists');
      final campsiteDoc = campsiteSnapshot.docs[0];
      final reviewsSnapshot =
          await campsiteDoc.reference.collection('reviews').get();

      return reviewsSnapshot.docs; // Return the reviews snapshot
    } else {
      print('campsite does not exist');
      return []; // Return an empty list if the campsite document doesn't exist
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
        future: fetchReviews(),
        builder: (BuildContext context,
            AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error fetching reviews');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final reviews = snapshot.data!;
          final averageRating = calculateAverageRating(reviews).toString();
          return Text(
            averageRating,
            style: TextStyle(fontSize: 22),
          );
        });
  }
}

double calculateAverageRating(List<QueryDocumentSnapshot> reviews) {
  double totalRating = 0;
  for (final review in reviews) {
    final rating = (review.data() as Map<String, dynamic>)['rating'] as double;
    totalRating += rating;
  }
  return totalRating / reviews.length;
}
