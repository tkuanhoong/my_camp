import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_camp/data/models/booking.dart';
import 'package:my_camp/data/models/campsite_event_model.dart';

class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Booking>> fetchUserBookings(userId) async {
    QuerySnapshot querySnapshot = await _db
        .collectionGroup('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return querySnapshot.docs
        .map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Booking>> fetchCampsiteBookings(String campsiteId) async {
    final List<Booking> campsiteBookings = [];
    // fetch campsite's booked events
    QuerySnapshot querySnapshot = await _db
        .collectionGroup('campsite_events')
        .where('campsiteId', isEqualTo: campsiteId)
        .get();
    // fetch bookings for each event
    for (final campsiteEvent in querySnapshot.docs) {
      QuerySnapshot bookingsSnapshot =
          await campsiteEvent.reference.collection('bookings').get();
      final eachBookingList = bookingsSnapshot.docs
          .map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      campsiteBookings.addAll(eachBookingList);
    }
    return campsiteBookings;
  }

  Future<void> addBooking(CampsiteEventModel campsiteEvent) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot documents = await _db
        .collectionGroup('campsite_events')
        .where('id', isEqualTo: campsiteEvent.id)
        .get();
    DocumentReference newBookingReference =
        documents.docs.first.reference.collection('bookings').doc();
    Booking booking = Booking(
      id: newBookingReference.id,
      userId: userId,
      amount: campsiteEvent.price,
      createdAt: DateTime.now(),
      campsiteEventId: campsiteEvent.id!,
    );
    await newBookingReference.set(booking.toMap());
  }
}
