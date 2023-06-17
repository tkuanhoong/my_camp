import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:my_camp/data/models/reviews.dart';

class ReviewsWidget extends StatelessWidget {
  final String campsiteId;
  const ReviewsWidget({
    Key? key,
    required this.campsiteId,
  });
  Future<List<Review>> fetchReviews() async {
    final campsiteSnapshot = await FirebaseFirestore.instance
        .collectionGroup('campsites')
        .where('id', isEqualTo: campsiteId)
        .get();

    if (campsiteSnapshot.docs.length > 0) {
      print('campsite exists');
      final campsiteDoc = campsiteSnapshot.docs[0];
      final reviewsSnapshot =
          await campsiteDoc.reference.collection('reviews').get();

      // Process the reviews snapshot and create Review objects
      final reviews =
          await Future.wait(reviewsSnapshot.docs.map((reviewDoc) async {
        final data = reviewDoc.data();
        final uid = data['uid'];
        print('review get uid test here');
        print(uid);
        final userSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        final String imagePath =
            userSnapshot.data()?['imagePath'] as String? ?? '';
        final String username =
            userSnapshot.data()?['name'] as String? ?? 'Anonymous';

        return Review(
          uid: data['uid'],
          username: username,
          review: data['review'],
          rating: data['rating'].toDouble(),
          timestamp: data['timestamp'].toDate(),
          imagePath: imagePath,
        );
      }));

      return reviews; // Return the reviews list
    } else {
      print('campsite does not exist');
      return []; // Return an empty list if the campsite document doesn't exist
    }
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return FutureBuilder<List<Review>>(
      future: fetchReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final reviews = snapshot.data ?? [];

          return Column(
            children: reviews.map((review) {
              String formattedDate = dateFormat.format(review.timestamp);
              return Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 48.0,
                        child: CircleAvatar(
                          radius: 24.0,
                          backgroundImage: review.imagePath != null
                              ? Image.network(review.imagePath!).image
                              : AssetImage('assets/images/profile_image.jpg'),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.username,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              RatingBar.builder(
                                initialRating: review.rating,
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
                              const SizedBox(width: 10.0),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  formattedDate,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      review.review,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider()
                ],
              );
            }).toList(),
          );
        }
      },
    );
  }
}
