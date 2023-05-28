import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_camp/data/models/campsite.dart';

class CampsiteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Campsite>> fetchCampsiteData({required campsitesList, required int limit, String? keyword, List? selectedStates, String? userId}) async {
    Query campsites;
    if(userId != null && userId.isNotEmpty){
      campsites = _db.collection('users').doc(userId).collection('campsites').where('verified', isEqualTo: true);
    } else{
      campsites = _db.collectionGroup('campsites').where('verified', isEqualTo: true);
    }
    
    if(keyword != null && keyword.isNotEmpty){
      campsites = campsites.where('name', isGreaterThanOrEqualTo: keyword).where('name', isLessThan: '$keyword\uf8ff');
    }
    if(selectedStates != null && selectedStates.isNotEmpty){
      campsites = campsites.where('state', whereIn: selectedStates);
    }

    if(campsitesList.isNotEmpty){
    QuerySnapshot startAfter = await campsites.where('id', isEqualTo: campsitesList.last.id).get();
    QueryDocumentSnapshot  startAfterDoc = startAfter.docs[startAfter.docs.length - 1];
      campsites = campsites.startAfterDocument(startAfterDoc).limit(limit);
    } else{
      campsites = campsites.limit(limit);
    }
    QuerySnapshot querySnapshot = await campsites.get();
    return querySnapshot.docs
        .map((doc) => Campsite.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
