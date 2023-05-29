import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_camp/data/models/user_model.dart';

class UserService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserModel> fetchUser({required String userId}) async {
    DocumentSnapshot documentSnapshot =
        await _db.collection('users').doc(userId).get();
    return UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<UserModel> updateUser(String userId,String name) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      await user.updateDisplayName(name);
      await _db.collection('users').doc(userId).update({
        'name': name
      });
      return await fetchUser(userId: userId);
    } catch (e) {
      rethrow;
    }
  }
}