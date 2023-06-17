import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_camp/data/models/campsite_event_model.dart';

class CampsiteEventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<CampsiteEventModel>> fetchCampsiteEvents(campsiteId) async {
    QuerySnapshot querySnapshot = await _db
        .collectionGroup('campsite_events')
        .where('campsiteId', isEqualTo: campsiteId)
        .where('deletedAt', isNull: true)
        .get();
    return querySnapshot.docs
        .map((doc) => CampsiteEventModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<CampsiteEventModel> fetchSingleCampsiteEvent(id) async {
    QuerySnapshot documents = await _db
        .collectionGroup('campsite_events')
        .where('id', isEqualTo: id)
        .get();
      return CampsiteEventModel.fromMap(
          documents.docs.first.data() as Map<String, dynamic>);
  }

  Future<void> addCampsiteEvent(CampsiteEventModel campsiteEvent) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference newCampsiteEvent = _db
        .collection('users')
        .doc(userId)
        .collection('campsites')
        .doc(campsiteEvent.campsiteId)
        .collection('campsite_events')
        .doc();
    campsiteEvent = campsiteEvent.copyWith(id: newCampsiteEvent.id);
    await newCampsiteEvent.set(campsiteEvent.toMap());
  }

  Future<void> updateCampsiteEvent(CampsiteEventModel campsiteEvent) async {
    await _db
        .collection('campsite_events')
        .doc(campsiteEvent.id)
        .update(campsiteEvent.toMap());
  }

  Future<void> deleteCampsiteEvent(String campsiteEventId) async {
    QuerySnapshot querySnapshot = await _db
        .collectionGroup('campsite_events')
        .where('id', isEqualTo: campsiteEventId)
        .get();
        
      await querySnapshot.docs.first.reference.update({"deletedAt": DateTime.now()});

  }

  Future<List<CampsiteEventModel>> fetchUserBookedCampsiteEvents(String userId) async {
    final bookingQuery =
        _db.collectionGroup('bookings').where('userId', isEqualTo: userId).orderBy('createdAt', descending: true);
    final campsiteEventPromises = <Future<DocumentSnapshot>>[];
    await bookingQuery.get().then((querySnapshot) async {
      for (final doc in querySnapshot.docs) {
        final campsiteDocRef = doc.reference.parent.parent!;
        campsiteEventPromises.add(campsiteDocRef.get());
      }
    });
    final campsiteEventSnapshots = await Future.wait(campsiteEventPromises);
    final List<CampsiteEventModel> campsiteEvents = campsiteEventSnapshots
        .map((snapshot) =>
            CampsiteEventModel.fromMap(snapshot.data() as Map<String, dynamic>))
        .toList();
    return campsiteEvents;
  }

  // Future<bool> verifyCampsiteEventOwner(userId, campsiteEventId) async {
  //   DocumentSnapshot documents = await _db
  //       .collection('users')
  //       .doc(userId)
  //       .collection('campsite_events')
  //       .doc(campsiteEventId)
  //       .get();
  //   if (documents.exists) {
  //     return true;
  //   }
  //   return false;
  // }

  // Future<List<CampsiteEvent>> fetchUserCampsiteEvents(userId) async{
  //   QuerySnapshot querySnapshot = await _db.collection('users').doc(userId).collection('campsite_events').get();
  //   return querySnapshot.docs.map((doc) => CampsiteEvent.fromMap(doc.data() as Map<String, dynamic>)).toList();
  // }

  // Future<List<CampsiteEvent>> fetchCampsiteEventsByCampsiteId(campsiteId) async{
  //   QuerySnapshot querySnapshot = await _db.collection('campsite_events').where('campsiteId', isEqualTo: campsiteId).get();
  //   return querySnapshot.docs.map((doc) => CampsiteEvent.fromMap(doc.data() as Map<String, dynamic>)).toList();
  // }

  // Future<List<CampsiteEvent>> fetchCampsiteEventsByUserId(userId) async{
  //   QuerySnapshot querySnapshot = await _db.collection('campsite_events').where('userId', isEqualTo: userId).get();
  //   return querySnapshot.docs.map((doc) => CampsiteEvent.fromMap(doc.data() as Map<String, dynamic>)).toList();
  // }

  // Future<List<CampsiteEvent>> fetchCampsiteEventsByUserIdAndCampsiteId(userId, campsiteId) async{
  //   QuerySnapshot querySnapshot = await _db.collection('campsite_events').where('userId', isEqualTo: userId).where('campsiteId', isEqualTo: campsiteId).get();
  //   return querySnapshot.docs.map((doc) => CampsiteEvent.fromMap(doc.data() as Map<String, dynamic>)).toList();
  // }
}
