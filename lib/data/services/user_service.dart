import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_camp/data/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as fireStorage;
import 'package:path/path.dart' as path;

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserModel> fetchUser({required String userId}) async {
    DocumentSnapshot documentSnapshot =
        await _db.collection('users').doc(userId).get();
    return UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<UserModel> updateUser(String userId, String name, File? image) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      if(image != null){
        // Upload the image to Firebase Storage
        final fileName = '$userId.${path.basename(image.path).split('.')[path.basename(image.path).split('.').length -1]}';
        final destination = 'images/user_profile/$fileName';

        fireStorage.Reference ref =
            fireStorage.FirebaseStorage.instance.ref(destination);
        fireStorage.UploadTask uploadTask = ref.putFile(image);
        await uploadTask.whenComplete(() {});
        String imagePath = await ref.getDownloadURL();
        await user.updatePhotoURL(imagePath);
        await _db.collection('users').doc(userId).update({'imagePath': imagePath});
      }

      await user.updateDisplayName(name);
      await _db.collection('users').doc(userId).update({'name': name});
      return await fetchUser(userId: userId);
    } catch (e) {
      rethrow;
    }
  }
}
