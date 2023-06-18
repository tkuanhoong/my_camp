import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AverageRatingAndQtyReviews extends StatelessWidget {
  final String campsiteId;

  const AverageRatingAndQtyReviews({
    Key? key,
    required this.campsiteId,
  });

  Future<List<QueryDocumentSnapshot>> fetchReviews() async {
    final campsiteSnapshot = await FirebaseFirestore.instance
        .collectionGroup('campsites')
        .where('id', isEqualTo: campsiteId)
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
          return CircularProgressIndicator(
            color: Colors.transparent,
          );
        }

        final reviews = snapshot.data!;
        final averageRating = calculateAverageRating(reviews);
        final qtyReviews = reviews.length;

        return Row(
          children: [
            RatingBar.builder(
              initialRating: averageRating.isNaN ? 0 : averageRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              ignoreGestures: true,
              itemCount: 5,
              itemSize: 24.0,
              itemPadding: EdgeInsets.zero,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
            ),
            SizedBox(width: 8.0),
            Text(
              '(${qtyReviews.toString()}) Reviews',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      },
    );
  }

  double calculateAverageRating(List<QueryDocumentSnapshot> reviews) {
    double totalRating = 0;
    for (final review in reviews) {
      final rating =
          (review.data() as Map<String, dynamic>)['rating'] as double;
      totalRating += rating;
    }
    return totalRating / reviews.length;
  }
}
