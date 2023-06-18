import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';
import 'campsite_details.dart';
import 'package:my_camp/router.dart';

class ReviewPage extends StatefulWidget {
  //required campsiteid and userid
  final String campsiteId;
  // final String userId;

  const ReviewPage(
      {required this.campsiteId,
      // required this.userId,
      Key? key})
      : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  String _reviewText = '';
  double _rating = 0;
  @override
  void initState() {
    super.initState();
    String campsiteId = widget.campsiteId;
    // print(campsiteId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Add a Review',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "What's your rate?",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 36.0,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 24.0),
                    const Text(
                      "What's your review?",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    TextField(
                      maxLines: 5,
                      onChanged: (value) {
                        setState(() {
                          _reviewText = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Write your review',
                        filled: true,
                        fillColor: Color(0xFFF1F1F1),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () {
                        saveReview(id: widget.campsiteId);
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveReview({required String id}) async {
    String campsiteId = id;
    print(id);
    if (_rating == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Rating is required'),
            content: const Text('Please provide a rating before saving.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (_reviewText.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Review is empty'),
            content: const Text('Please write a review before saving.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Perform save operation here with _reviewText and _rating
    // _reviewText
    // _rating

    // DocumentReference campsiteRef = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId)
    //     .collection('campsites')
    //     .doc(campsiteId);
    // CollectionReference reviewCollection = campsiteRef.collection('reviews');
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .where(FieldPath.documentId, isEqualTo: campsiteId)
    //     .limit(1)
    //     .get()
    //     .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    //   if (querySnapshot.docs.isNotEmpty) {
    //     var parentDocumentId = querySnapshot.docs[0].id;
    //     print('Parent document ID: $parentDocumentId');
    //   } else {
    //     // The campsite or its parent does not exist
    //     print(campsiteId);
    //     print('The campsite or its parent does not exist');
    //   }
    // }).catchError((error) {
    //   // Handle any error that occurred
    //   print(error);
    // });

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collectionGroup('campsites')
        .where('id', isEqualTo: campsiteId)
        .get();

    var uid = FirebaseAuth.instance.currentUser!.uid;

// get imagepath from firebase storage users collection
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;

      // You can then retrieve the value from the Map like this:
      var imagepath = data['imagePath'];
    }

    snapshot.docs.first.reference.collection('reviews').add({
      'uid': uid,
      'review': _reviewText,
      'rating': _rating,
      'timestamp': DateTime.now(),
    });

    // saveReviewToDatabase(_reviewText, _rating);
// navigate back to campsite details page

    Navigator.pop(context);
  }
}
